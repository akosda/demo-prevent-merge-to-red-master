#!/bin/bash -eu

export TOKEN=$1

# preview API
curl \
  -XPUT \
  -H "Authorization: token ${TOKEN}"  \
  -H "Accept: application/vnd.github.loki-preview+json" \
  https://api.github.com/repos/akosda/demo-prevent-merge-to-red-master/branches/master/protection \
  -d "{
  \"required_status_checks\": {
    \"include_admins\": true,
    \"strict\": true,
    \"contexts\": []
  },
  \"required_pull_request_reviews\": null,
  \"restrictions\": null
}"
