#!/bin/bash

set -e

if [[ -z "${TM_TOKEN_KEY}" ]]; then
  echo "Error: missing TM_TOKEN_KEY env variable"
  exit 1
fi


# overview of process: create a snapshot with the input source, analyze it, then download the result as a pdf report

echo "Create a snapshot"
COMMAND_OUTPUT=$(npx @testmachine.ai/cli -t ${TM_TOKEN_KEY} snapshot create --repo-id ${1} --file ${2} --output=json)

# attempt parse json output from previous command, show error in console if failed to parse
SNAPSHOT_ID=$(jq '.ID' <<< "$COMMAND_OUTPUT") || echo "Cannot parse output from command because: $COMMAND_OUTPUT"
if [[ ! -z $SNAPSHOT_ID && $SNAPSHOT_ID != "null" ]]; then
    echo "Created Snapshot Id for analysis: $SNAPSHOT_ID"
    COMMAND_OUTPUT=$(npx @testmachine.ai/cli -t ${TM_TOKEN_KEY} snapshot analyze --snapshot-id=${SNAPSHOT_ID} --output=json)
    # attempt parse json output from previous command, show error in console if failed to parse
    ANA_ID=$(jq '.id' <<< "$COMMAND_OUTPUT")
    if [[ ! -z $ANA_ID && $ANA_ID != "null" ]]; then
        echo "Requesting report for generated Analysis Id: $ANA_ID"
        COMMAND_OUTPUT=$(npx @testmachine.ai/cli -t ${TM_TOKEN_KEY} analyses report --analysis-id=${ANA_ID} --output=json)
        # attempt parse json output from previous command, show error in console if failed to parse
        DOWNLOAD_URL=$(jq '.downloadURLOfGeneratedReport' <<< "$COMMAND_OUTPUT")
        if [[ ! -z $DOWNLOAD_URL && $DOWNLOAD_URL != "null" ]]; then
            # remove double quotes from beginning and end of download url
            temp="${DOWNLOAD_URL%\"}"
            DOWNLOAD_URL="${temp#\"}"
            # download file
            echo "Downloading generated report PDF download URL: $DOWNLOAD_URL"
            wget -O action_work_result_report.pdf ${DOWNLOAD_URL}
        fi
    fi
fi
