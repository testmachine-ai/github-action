#!/bin/bash

set -e

if [[ -z "${TM_TOKEN_KEY}" ]]; then
  echo "Error: missing TM_TOKEN_KEY env variable"
  exit 1
fi

if [[ -z "${TM_API_URL}" ]]; then
  echo "Error: missing TM_API_URL env variable"
  exit 1
fi

npx @testmachine.ai/cli -t ${TM_TOKEN_KEY} snapshot create-analyze --repo-id ${1} --file ${2}
