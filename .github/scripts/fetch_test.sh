#!/usr/bin/env bash

shopt -s lastpipe

declare -A __app
find ./apps -name metadata.json5 | while read -r metadata; do
    declare -a __channels=()
    app="$(jq --raw-output '.app' "${metadata}")"
    jq --raw-output -c '.channels | .[]' "${metadata}" | while read -r channels; do
        channel="$(jq --raw-output '.name' <<< "${channels}")"
        stable="$(jq --raw-output '.stable' <<< "${channels}")"
        published_version=$(./.github/scripts/versions/published.sh "${app}" "${channel}" "${stable}")
        upstream_version=$(./.github/scripts/versions/upstream.sh "${app}" "${channel}" "${stable}")
        if [[ "${published_version#*v}" != "${upstream_version}" ]]; then
            echo "${app}/${channel}: ${published_version#*v} -> ${upstream_version}"
            __channels+=("${channel}")
        fi
    done
    if [[ "${#__channels[@]}" -gt 0 ]]; then
        __app[$app]="${__channels[*]}"
    fi
done

declare -a __apps=()
for app in "${!__app[@]}"; do
    #shellcheck disable=SC2086
    app=$(jo app="$app" channels="$(jo -a -- -s ${__app[$app]})")
    __apps+=("${app}")
done

#shellcheck disable=SC2048,SC2086
echo "::set-output name=changes::$(jo changes="$(jo -a ${__apps[*]})")"
