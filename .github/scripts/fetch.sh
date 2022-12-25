#!/usr/bin/env bash
# FIXME: Consider rewriting this in Python3

# Overview:
# Builds a JSON string what images and their channels to process
# Outputs:
# [
#    {"app":"ubuntu", "channel": "focal"},
#    {"app":"ubuntu", "channel": "jammy"},
#    {"app"...
# ]

shopt -s lastpipe

FETCH_ALL=false
if [ "$1" == "all" ]; then
    FETCH_ALL=true
fi

declare -A app_channel_array
find ./apps -name metadata.json | while read -r metadata; do
    declare -a __channels=()
    app="$(jq --raw-output '.app' "${metadata}")"
    jq --raw-output -c '.channels | .[]' "${metadata}" | while read -r channels; do
        channel="$(jq --raw-output '.name' <<< "${channels}")"
        stable="$(jq --raw-output '.stable' <<< "${channels}")"
        if [ ${FETCH_ALL} == true ]; then
            __channels+=("${channel}")
        else
            published_version=$(./.github/scripts/published.sh "${app}" "${channel}" "${stable}")
            upstream_version=$(./.github/scripts/upstream.sh "${app}" "${channel}" "${stable}")
            if [[ "${published_version}" != "${upstream_version}" && "${upstream_version}" != "" && "${upstream_version}" != "null" ]]; then
                echo "${app}$([[ ! ${stable} == false ]] || echo "-${channel}"):${published_version:-<NOTFOUND>} -> ${upstream_version}"
                __channels+=("${channel}")
            fi
        fi
    done
    if [[ "${#__channels[@]}" -gt 0 ]]; then
        app_channel_array[$app]="${__channels[*]}"
    fi
done

output="[]"
if [[ "${#app_channel_array[@]}" -gt 0 ]]; then
    declare -a changes_array=()
    for app in "${!app_channel_array[@]}"; do
        #shellcheck disable=SC2086
        if [[ -n "${app}" ]]; then
            for channel in ${app_channel_array[$app]}; do
                changes_array+=("$(jo app="$app" channel="$channel")")
            done
        fi
    done
    #shellcheck disable=SC2048,SC2086
    output="$(jo -a ${changes_array[*]})"
fi

echo "changes=${output}" >> $GITHUB_OUTPUT
