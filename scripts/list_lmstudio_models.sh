#!/usr/bin/env bash

curl -s http://localhost:1234/api/v1/models | jq '.models[] | {key, max_context_length,format}'
