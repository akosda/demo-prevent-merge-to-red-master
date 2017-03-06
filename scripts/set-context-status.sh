#!/bin/bash -eu

# preview API
curl \
  -XPOST \
  -H "Authorization: token ${1}"  \
  -H "Accept: application/vnd.github.loki-preview+json" \
  https://api.github.com/repos/akosda/demo-prevent-merge-to-red-master/statuses/${2} \
  -d "{
    \"state\": \"success\",
    \"target_url\": \"https://ci.da-int.net/job/apollo/job/master\",
    \"description\": \"Fixing red master\",
    \"context\": \"continuous-integration/master-is-red\"
}"
