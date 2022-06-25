#!/usr/bin/env bash

# shopt -s lastpipe

# __container_versions=()
# find ./apps/ -mindepth 1 -maxdepth 1 -type d | while read -r app; do
#     echo "${app}"
# done

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
        if [[ "${published_version}" != "${upstream_version}" ]]; then
            echo "${app}/${channel}: ${published_version} -> ${upstream_version}"
            __channels+=("${channel}")
        fi
        # __channels+=("${channel}")
    done
    __app[$app]="${__channels[*]}"
done

# for key in "${!__app[@]}"; do
#     #shellcheck disable=SC2086
#     jo app="$key" channels="$(jo -a ${__app[$key]})"
# done

# printf "%s" "${arr[@]}"
