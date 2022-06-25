#!/usr/bin/env bash

APP="${1}"
CHANNEL="${2}"
STABLE="${3}"
TOKEN="${TOKEN:-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}"

if [[ -n "${APP}" && -n "${CHANNEL}" && "${STABLE}" != true ]]; then
    APP="${APP}-${CHANNEL}"
fi


tags=$( \
    curl -fsSL \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: token ${TOKEN}" \
        "https://api.github.com/users/onedr0p/packages/container/${APP}/versions" \
        2>/dev/null
)

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
