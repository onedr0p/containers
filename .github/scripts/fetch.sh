#!/usr/bin/env bash
# FIXME: Consider rewriting this in Python3

# Overview:
# Builds a JSON string what images and their channels to process
# Outputs:
# {"changes":[
#    {"app":"ubuntu","channels":["focal","jammy"]},
#    {"app"...
# ]}

shopt -s lastpipe

declare -A app_channel_array
find ./apps -name metadata.json5 | while read -r metadata; do
    declare -a __channels=()
    app="$(jq --raw-output '.app' "${metadata}")"
    jq --raw-output -c '.channels | .[]' "${metadata}" | while read -r channels; do
        channel="$(jq --raw-output '.name' <<< "${channels}")"
        stable="$(jq --raw-output '.stable' <<< "${channels}")"
        published_version=$(./.github/scripts/published.sh "${app}" "${channel}" "${stable}")
        upstream_version=$(./.github/scripts/upstream.sh "${app}" "${channel}" "${stable}")
        if [[ "${published_version}" != "${upstream_version}" ]]; then
            echo "${app}$([[ ! ${stable} == false ]] || echo "-${channel}"):${published_version:-<NOTFOUND>} -> ${upstream_version}"
            __channels+=("${channel}")
        fi
    done
    if [[ "${#__channels[@]}" -gt 0 ]]; then
        app_channel_array[$app]="${__channels[*]}"
    fi
done

output="$(jo changes=[])"
if [[ "${#app_channel_array[@]}" -gt 0 ]]; then
    declare -a changes_array=()
    for app in "${!app_channel_array[@]}"; do
        #shellcheck disable=SC2086
        if [[ -n "${app}" ]]; then
            changes_array+=("$(jo app="$app" push=true channels="$(jo -a ${app_channel_array[$app]})")")
        fi
    done
    #shellcheck disable=SC2048,SC2086
    output="$(jo changes="$(jo -a ${changes_array[*]})")"
fi

echo "::set-output name=changes::${output}"
