#!/usr/bin/env bash

# Usage: ./test_openai_api_key.sh API_KEY

API_KEY="$1"

if [ -z "$API_KEY" ]; then
  echo "Usage: $0 OPENAI_API_KEY"
  exit 1
fi

URL="https://api.openai.com/v1/models"

HTTP_RESPONSE=$(curl -s -w "\n%{http_code}" "$URL" \
  -H "Authorization: Bearer $API_KEY")

HTTP_STATUS=$(echo "$HTTP_RESPONSE" | tail -n1)

if [ "$HTTP_STATUS" -eq 200 ]; then
  echo "VALID"
else
  echo "INVALID"
fi
