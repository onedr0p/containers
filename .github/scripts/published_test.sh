#!/usr/bin/env bash

# ubuntu:focal-rolling        # stable=true       # base=true
# ubuntu:focal-19880312       # stable=true       # base=true
# alpine:rolling              # stable=true       # base=true
# alpine:3.16.0               # stable=true       # base=true
# lidarr-develop:0.1.0        # stable=false      # base=false
# lidarr-develop:rolling      # stable=false      # base=false
# lidarr:1.0.0                # stable=true       # base=false
# lidarr:rolling              # stable=true       # base=false

APP="${1}"
CHANNEL="${2}"
STABLE="${3}"
TOKEN="${TOKEN:-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}"

if [[ "${STABLE}" != true ]]; then
    APP="${APP}-${CHANNEL}"
fi

tags=$( \
    curl -fsSL \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: token ${TOKEN}" \
        "https://api.github.com/users/onedr0p/packages/container/${APP}/versions" \
        2>/dev/null
)

# echo ${tags}

# exit 1

if [[ -z "${tags}" ]]; then
    exit 0
fi

current_tags=$( \
    jq --compact-output \
        'map( select( .metadata.container.tags[] | contains("rolling") ) | .metadata.container.tags[] )' \
            <<< "${tags}" \
)

# echo "${current_tags}" | jq --raw-output

tag=$( \
    jq --compact-output \
        'map( select( index("rolling") | not ) )' \
            <<< "${current_tags}"
)

# echo "${tags}" | jq --raw-output

printf "%s" "$(jq --raw-output '.[0]' <<< "${tag}")"
