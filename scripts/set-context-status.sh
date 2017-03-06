#!/bin/bash -eu

set -x
export TOKEN=$1
export COMMIT_ID=$2
export COMMIT_MSG=$3
set +x

if [[ ${COMMIT_MSG} == *"fix-master-job"* ]]; then
  echo "Setting continuous-integration/master-is-red context on ${COMMIT_ID} to 'success'..."
  # preview API
  curl \
    -XPOST \
    -H "Authorization: token ${TOKEN}"  \
    -H "Accept: application/vnd.github.loki-preview+json" \
    https://api.github.com/repos/akosda/demo-prevent-merge-to-red-master/statuses/${COMMIT_ID} \
    -d "{
      \"state\": \"success\",
      \"target_url\": \"https://ci.da-int.net/job/apollo/job/master\",
      \"description\": \"Fixing red master\",
      \"context\": \"continuous-integration/master-is-red\"
  }"
else
  echo "Commit message does not contain 'fix-master-job'. Skipping GitHub API call."
fi
