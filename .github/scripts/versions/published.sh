#!/usr/bin/env bash

APP="${1}"
CHANNEL="${2}"
STABLE="${3}"

if [[ -n "${APP}" && -n "${CHANNEL}" && "${STABLE}" != true ]]; then
    APP="${APP}-${CHANNEL}"
fi


tags=$( \
    curl -fsSL \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: token ${TOKEN}" \
        "https://api.github.com/users/onedr0p/packages/container/${APP}/versions" \
)

current_tags=$( \
    jq --compact-output \
        'map( select( .metadata.container.tags[] | contains("rolling") ) | .metadata.container.tags[] )' \
            <<< "${tags}" \
)

tag=$( \
    jq --compact-output \
        'map( select( index("rolling") | not ) )' \
            <<< "${current_tags}"
)

printf "%s" "$(jq --raw-output '.[0]' <<< "${tag}")"
