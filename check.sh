#!/bin/bash

set -e

exec 3>&1
exec 1>&2

set +x

port=""
if [[ -n "${SMUGGLER_port}:-" ]]; then
  port=":${SMUGGLER_port}"
fi

echo "machine ${SMUGGLER_host} login ${SMUGGLER_user} password ${SMUGGLER_pass}" > ~/.netrc

job_url="${SMUGGLER_protocol:-https}://${SMUGGLER_host}${port}${SMUGGLER_job}"

set -x
curl -sS --max-time 10 --retry 3 -n "${job_url}/api/json" > "${SMUGGLER_OUTPUT_DIR}/raw"
set +x

jq '.builds | .[].number' < "${SMUGGLER_OUTPUT_DIR}/raw" | tac > "${SMUGGLER_OUTPUT_DIR}/versions"
