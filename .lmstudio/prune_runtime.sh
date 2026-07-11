#!/usr/bin/env bash

set -euo pipefail

echo "Fetching installed runtimes..."
RAW_OUTPUT="$(lms runtime ls)"

ROWS=()
while IFS= read -r line; do
  [ -n "$line" ] && ROWS+=("$line")
done < <(echo "$RAW_OUTPUT" | grep -E '^[^[:space:]]+@[^[:space:]]+' || true)

TO_REMOVE=()
KEEP=""

if [ "${#ROWS[@]}" -gt 0 ]; then
  for row in "${ROWS[@]}"; do
    name="$(echo "$row" | awk '{print $1}')"
    if echo "$row" | grep -q '✓'; then
      KEEP="$name"
    else
      TO_REMOVE+=("$name")
    fi
  done
fi

if [ -z "$KEEP" ]; then
  echo "Warning: no runtime is currently marked as selected (✓)." >&2
  echo "Refusing to guess which one to keep. Run 'lms runtime select' first." >&2
  exit 1
fi

if [ "${#TO_REMOVE[@]}" -eq 0 ]; then
  echo "Nothing to prune."
  exit 0
fi

for r in "${TO_REMOVE[@]}"; do
  echo "Removing $r ..."
  printf 'Y\n' | lms runtime remove "$r"
done
