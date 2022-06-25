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
    # [[ "${app}" == "ubuntu" || "${app}" == "alpine" ]] && continue
    jq --raw-output -c '.channels | .[]' "${metadata}" | while read -r channels; do
        channel="$(jq --raw-output '.name' <<< "${channels}")"
        stable="$(jq --raw-output '.stable' <<< "${channels}")"
        published_version=$(./.github/scripts/versions/published.sh "${app}" "${channel}" "${stable}")
        upstream_version=$(./.github/scripts/versions/upstream.sh "${app}" "${channel}" "${stable}")
        echo ${published_version#*v}
        echo ${upstream_version}
        # [[ -n "${published_version}" ]] && published_version="${upstream_version}"
        if [[ ! "${published_version#*v}" =~ ${upstream_version} ]]; then
            # echo "${app}/${channel}: ${published_version#*v} -> ${upstream_version}"
            __channels+=("$(jo -- -s name="${channel}" -s published="${published_version#*v}" -s upstream="${upstream_version}")")
        fi
    done
    #shellcheck disable=SC2048,SC2086
    __app[$app]="$(jo -a ${__channels[*]})"

    printf "%s" "${__channels[*]}"
done

# declare -a __apps=()
# for key in "${!__app[@]}"; do
#     app="$(jo app="$key" channels="${__app[$key]}")"
#     __apps+=("${app}")
# done

# #shellcheck disable=SC2048,SC2086
# jo changes="$(jo -a ${__apps[*]})" | jq --raw-output

# #shellcheck disable=SC2048,SC2086
# echo "::set-output name=changes::$(jo -a ${__apps[*]})"

# printf "%s" "$(jo changes="$(jo -a ${__apps[*]})")"

# declare -a __apps=()
# for key in "${!__app[@]}"; do
#     #shellcheck disable=SC2086
#     app=$(jo app="$key" channels="$(jo -a ${__app[$key]})")
#     __apps+=("${app}")
# done

# # printf "%s" "$(jo changes="$(jo -a ${__apps[*]})")"

# #shellcheck disable=SC2048,SC2086
# echo "::set-output name=changes::$(jo changes="$(jo -a ${__apps[*]})")"
