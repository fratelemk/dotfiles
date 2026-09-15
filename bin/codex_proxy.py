#!/usr/bin/env python3
"""
Logging passthrough proxy: codex -> :11500 -> LM Studio :1234

Logs every request body (pretty JSON) and the first chunk of the response
to stderr, then streams the rest through unchanged. Designed to diagnose
what `tools` Codex actually sends when pointed at LM Studio, and to fix
the MCP namespace-wrapper issue (codex#26234) by flattening
{"type": "namespace", ...} tool entries into flat function tools before
they reach LM Studio, then rewriting function_call names back on the way
out so codex's MCP router can dispatch them correctly.

Usage:
    lms load openai/gpt-oss-20b --parallel 1 --context-length 131072
    CODEX_OSS_BASE_URL=http://localhost:11500/v1 codex --oss --local-provider lmstudio -m openai/gpt-oss-20b 
    python3 /tmp/codex_lmstudio_proxy.py 2> /tmp/codex_proxy.log

Then in another terminal, point codex's custom provider at the proxy
instead of LM Studio directly (see notes at bottom of this file for the
config.toml change — CODEX_OSS_BASE_URL only applies to `codex --oss`,
not to a hand-defined [model_providers.*] entry).
"""
import http.server
import json
import os
import socketserver
import sys
import time
import urllib.error
import urllib.request

UPSTREAM = "http://localhost:1234"  # LM Studio's default OpenAI-compatible port
LISTEN_HOST = "127.0.0.1"
LISTEN_PORT = 11500

# Set EXPAND_NAMESPACES=0 to disable rewriting (pure passthrough mode).
EXPAND_NAMESPACES = os.environ.get("EXPAND_NAMESPACES", "1") != "0"

# Side directory for full request/response body dumps so we don't blow up
# the main log with multi-hundred-KB payloads.
BODY_DUMP_DIR = "/tmp/codex_proxy_bodies"
os.makedirs(BODY_DUMP_DIR, exist_ok=True)

# Hop-by-hop headers we must not forward.
HOP_BY_HOP = {
    "connection", "keep-alive", "proxy-authenticate", "proxy-authorization",
    "te", "trailers", "transfer-encoding", "upgrade", "host", "content-length",
}


def log(msg: str) -> None:
    print(msg, file=sys.stderr, flush=True)


_ALT_SEPARATORS = (":", ".", "/", "-")


def normalize_function_call_name(name, namespaces):
    """Map a tool name from the model's function_call event back to codex's
    canonical (namespace, tool_name) form.

    `namespaces` is the list of canonical namespace prefixes that we
    enumerated from the request (e.g., 'mcp__cloudflare-blog__'). Returns
    (rewritten_name, namespace_or_None). When the name doesn't match any
    known namespace pattern, returns (name, None) unchanged.

    Handles two failure modes from local models:
      1. Wrong separator: 'mcp:cloudflare-blog:list_posts'
         -> normalize to 'mcp__cloudflare-blog__list_posts'
      2. Flat form even when separator is right: codex routes by
         (namespace, name) pair, so we split off the prefix.
    """
    if not isinstance(name, str) or not name or not namespaces:
        return name, None

    candidates = [name]
    if "__" not in name:
        for sep in _ALT_SEPARATORS:
            if sep in name:
                candidates.append(name.replace(sep, "__"))

    for cand in candidates:
        for ns in namespaces:
            if cand.startswith(ns) and len(cand) > len(ns):
                return cand[len(ns):], ns
    return name, None


def rewrite_function_calls_in_event(parsed_data, namespaces):
    """Walk an SSE `data: {...}` payload and rewrite any function_call items
    to use the (name, namespace) split that codex's MCP router expects.

    Mutates `parsed_data` in place. Returns the count of rewritten items.
    """
    rewritten = 0

    def visit(node):
        nonlocal rewritten
        if isinstance(node, dict):
            if node.get("type") == "function_call" and "name" in node:
                new_name, ns = normalize_function_call_name(node["name"], namespaces)
                if ns is not None and node["name"] != new_name:
                    node["name"] = new_name
                    node["namespace"] = ns
                    rewritten += 1
            for value in node.values():
                visit(value)
        elif isinstance(node, list):
            for item in node:
                visit(item)

    visit(parsed_data)
    return rewritten


def expand_namespace_tools(parsed):
    """Replace each `namespace`-typed tool with its inner `function` tools,
    flattened into the top-level tools[]. Names get prefixed with the namespace
    name when not already prefixed, so codex's tool router can route function
    calls back to the right MCP server.

    Returns (new_parsed, expansion_summary). expansion_summary is a list of
    (namespace_name, inner_tool_count) tuples for logging.
    """
    summary = []
    if not isinstance(parsed, dict):
        return parsed, summary
    tools = parsed.get("tools")
    if not isinstance(tools, list):
        return parsed, summary

    new_tools = []
    for tool in tools:
        if isinstance(tool, dict) and tool.get("type") == "namespace":
            ns_name = tool.get("name", "") or ""
            inner = tool.get("tools") or []
            inner_count = 0
            for inner_tool in inner:
                if not isinstance(inner_tool, dict):
                    continue
                # Inner entries are wrapped: {"type":"function", ...rest of ResponsesApiTool}
                if inner_tool.get("type") == "function":
                    expanded = {k: v for k, v in inner_tool.items()}
                    raw_name = expanded.get("name", "") or ""
                    # Prefix with the namespace only if not already prefixed.
                    if ns_name and not raw_name.startswith(ns_name):
                        expanded["name"] = f"{ns_name}{raw_name}"
                    new_tools.append(expanded)
                    inner_count += 1
            summary.append((ns_name, inner_count))
        else:
            new_tools.append(tool)
    parsed["tools"] = new_tools
    return parsed, summary


class ProxyHandler(http.server.BaseHTTPRequestHandler):
    # Use HTTP/1.0 so each request gets its own TCP connection. Avoids the
    # keep-alive framing pitfalls of doing HTTP/1.1 properly in a tiny proxy.
    protocol_version = "HTTP/1.0"

    def _proxy(self):
        length = int(self.headers.get("Content-Length") or 0)
        body = self.rfile.read(length) if length else b""
        ts = time.strftime("%H%M%S")

        log("\n" + "=" * 78)
        log(f">>> {self.command} {self.path}")
        log("--- request headers ---")
        for k, v in self.headers.items():
            if k.lower() not in {"authorization", "cookie"}:
                log(f"  {k}: {v}")

        # Optionally rewrite POST /v1/responses bodies to expand namespace tools.
        rewritten_body = body
        parsed_body = None
        is_responses_post = self.command == "POST" and self.path.startswith("/v1/responses")
        if body:
            try:
                parsed_body = json.loads(body)
            except json.JSONDecodeError:
                parsed_body = None

        # Namespace prefixes seen on the request — used to rewrite the response.
        request_namespaces = []
        if is_responses_post and EXPAND_NAMESPACES and isinstance(parsed_body, dict):
            parsed_body, summary = expand_namespace_tools(parsed_body)
            if summary:
                log(f"--- expanded {len(summary)} namespace(s) ---")
                for ns, count in summary:
                    log(f"  - {ns} -> {count} function(s)")
                    if ns:
                        request_namespaces.append(ns)
                rewritten_body = json.dumps(parsed_body).encode()

        # Dump full original + rewritten request to side files for inspection.
        if body:
            req_dump = os.path.join(BODY_DUMP_DIR, f"{ts}-req-orig.json")
            with open(req_dump, "wb") as fh:
                fh.write(body)
            log(f"--- full original request body -> {req_dump} ({len(body)} bytes) ---")
            if rewritten_body is not body:
                rew_dump = os.path.join(BODY_DUMP_DIR, f"{ts}-req-rewritten.json")
                with open(rew_dump, "wb") as fh:
                    fh.write(rewritten_body)
                log(f"--- rewritten request body -> {rew_dump} ({len(rewritten_body)} bytes) ---")

        if body and not is_responses_post:
            log("--- request body ---")
            try:
                pretty = json.dumps(json.loads(body), indent=2)
                if len(pretty) > 4000:
                    log(pretty[:4000])
                    log(f"... [truncated, total {len(pretty)} chars]")
                else:
                    log(pretty)
            except json.JSONDecodeError:
                log(repr(body[:2000]))

        if is_responses_post and isinstance(parsed_body, dict):
            tools = parsed_body.get("tools")
            if isinstance(tools, list):
                log(f"--- tools[] count after rewrite: {len(tools)} ---")
                for t in tools[:200]:
                    if not isinstance(t, dict):
                        continue
                    log(f"  - {t.get('type', '?')}: {t.get('name', '<?>')}")

        # Build upstream request, dropping hop-by-hop headers.
        fwd_headers = {k: v for k, v in self.headers.items() if k.lower() not in HOP_BY_HOP}
        url = f"{UPSTREAM}{self.path}"
        req = urllib.request.Request(url, data=rewritten_body or None, headers=fwd_headers, method=self.command)

        try:
            upstream = urllib.request.urlopen(req, timeout=600)
        except urllib.error.HTTPError as e:
            log(f"<<< upstream HTTPError {e.code}")
            self.send_response(e.code)
            for k, v in e.headers.items():
                if k.lower() not in HOP_BY_HOP:
                    self.send_header(k, v)
            self.end_headers()
            err_body = e.read()
            log("--- upstream error body ---")
            log(err_body[:4000].decode(errors="replace"))
            self.wfile.write(err_body)
            return
        except Exception as e:
            log(f"<<< upstream connection error: {e}")
            self.send_error(502, str(e))
            return

        log(f"<<< upstream {upstream.status}")
        log("--- response headers ---")
        for k, v in upstream.headers.items():
            log(f"  {k}: {v}")

        self.send_response(upstream.status)
        for k, v in upstream.headers.items():
            if k.lower() not in HOP_BY_HOP:
                self.send_header(k, v)
        # Always close the client connection after each response so reqwest
        # (codex) opens a fresh TCP socket for the next call. Eliminates a
        # whole class of keep-alive framing bugs.
        self.send_header("Connection", "close")
        self.close_connection = True
        is_sse = "text/event-stream" in (upstream.headers.get("Content-Type") or "")
        self.end_headers()

        should_rewrite_sse = (
            is_sse and is_responses_post and EXPAND_NAMESPACES and request_namespaces
        )

        resp_dump_path = None
        resp_dump_fh = None
        if is_responses_post:
            resp_dump_path = os.path.join(BODY_DUMP_DIR, f"{ts}-resp.sse")
            resp_dump_fh = open(resp_dump_path, "wb")
            log(f"--- response stream -> {resp_dump_path} ---")

        first = True
        rewrites_total = 0
        try:
            if should_rewrite_sse:
                buf = bytearray()
                while True:
                    chunk = upstream.read(4096)
                    if not chunk:
                        if buf:
                            self.wfile.write(bytes(buf))
                            if resp_dump_fh:
                                resp_dump_fh.write(bytes(buf))
                            buf.clear()
                        break
                    if first:
                        log("--- first response chunk (preview) ---")
                        log(chunk[:1500].decode(errors="replace"))
                        first = False
                    if resp_dump_fh:
                        resp_dump_fh.write(chunk)
                    buf.extend(chunk)
                    while True:
                        nl = buf.find(b"\n")
                        if nl < 0:
                            break
                        line_bytes = bytes(buf[: nl + 1])
                        del buf[: nl + 1]
                        out_line = line_bytes
                        stripped = line_bytes.rstrip(b"\r\n")
                        if stripped.startswith(b"data: "):
                            payload = stripped[len(b"data: "):]
                            if payload and payload[:1] in (b"{", b"["):
                                try:
                                    parsed_event = json.loads(payload)
                                except (json.JSONDecodeError, UnicodeDecodeError):
                                    parsed_event = None
                                if parsed_event is not None:
                                    n = rewrite_function_calls_in_event(
                                        parsed_event, request_namespaces
                                    )
                                    if n:
                                        rewrites_total += n
                                        new_payload = json.dumps(parsed_event).encode()
                                        suffix = line_bytes[len(stripped):]
                                        out_line = b"data: " + new_payload + suffix
                                        log(
                                            f"  rewrote {n} function_call name(s) in event"
                                        )
                        self.wfile.write(out_line)
                        self.wfile.flush()
                if rewrites_total:
                    log(f"--- total function_call name rewrites: {rewrites_total} ---")
            else:
                while True:
                    chunk = upstream.read(4096)
                    if not chunk:
                        break
                    if first:
                        log("--- first response chunk (preview) ---")
                        log(chunk[:1500].decode(errors="replace"))
                        first = False
                    if resp_dump_fh:
                        resp_dump_fh.write(chunk)
                    self.wfile.write(chunk)
                    self.wfile.flush()
        except (BrokenPipeError, ConnectionResetError) as e:
            log(f"<<< client disconnected: {e}")
        finally:
            if resp_dump_fh:
                resp_dump_fh.close()

    def do_GET(self):
        self._proxy()

    def do_POST(self):
        self._proxy()

    def do_DELETE(self):
        self._proxy()

    def do_PUT(self):
        self._proxy()

    def log_message(self, format, *args):
        return


class ThreadedServer(socketserver.ThreadingMixIn, http.server.HTTPServer):
    daemon_threads = True
    allow_reuse_address = True


if __name__ == "__main__":
    log(f"listening on http://{LISTEN_HOST}:{LISTEN_PORT}  ->  {UPSTREAM}")
    log("point codex's model_providers.lmstudio_local.base_url at:")
    log(f"    http://{LISTEN_HOST}:{LISTEN_PORT}/v1")
    log("(CODEX_OSS_BASE_URL only works with `codex --oss`, not a custom")
    log(" [model_providers.*] entry — see config.toml note in this file's docstring)")
    ThreadedServer((LISTEN_HOST, LISTEN_PORT), ProxyHandler).serve_forever()
