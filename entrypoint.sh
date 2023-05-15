#!/bin/bash

set -e

if [[ -z "${TOKEN_KEY}" ]]; then
  echo "Error: missing TOKEN_KEY env variable"
  exit 1
fi

if [[ -z "${API_URL}" ]]; then
  echo "Error: missing API_URL env variable"
  exit 1
fi

npx @testmachine.ai/cli -t ${TOKEN_KEY} snapshot create-analyze --repo-id ${1} --file ${2}
