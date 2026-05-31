#!/usr/bin/env bash

set -euo pipefail

status=$(lms daemon status)

if echo "$status" | grep -qi "not running"; then
    was_running=false
else
    was_running=true
    echo "Stopping daemon..."
    lms daemon down
fi

echo "Updating..."
lms daemon update
lms runtime update --all --yes

if $was_running; then
    echo "Starting daemon..."
    lms daemon up
fi
