#!/usr/bin/env bash

set -euo pipefail

daemon_status=$(lms daemon status --json)
if echo "$daemon_status" | grep -q '"running":true'; then
  echo "Daemon already running."
else
  echo "Starting daemon..."
  lms daemon up
fi

server_status=$(lms server status --json)
if echo "$server_status" | grep -q '"running":true'; then
  echo "Server already running."
else
  echo "Starting server..."
  lms server start
fi
