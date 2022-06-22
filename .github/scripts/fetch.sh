#!/usr/bin/env bash

shopt -s lastpipe

__container_versions=()
find . -name metadata.json | while read -r metadata; do
    __app=$(echo "${metadata}" | awk -F / '{print $3}')
    __current_version=$(jq --raw-output ".__current_version" "${metadata}")
    __stream=$(echo "${metadata}" | awk -F / '{print $4}')
    __latest_version="$(bash "$(dirname "$(dirname "${metadata}")")"/latest-version.sh "${__stream}")"
    if [[ -n "${__latest_version}" || "${__latest_version}" != "null" ]]; then
        jq --arg v "$__latest_version" '.__current_version = $v' "${metadata}" | sponge "${metadata}"
        jq '.__build_status.__success = true' "${metadata}" | sponge "${metadata}"
        echo "${__app} | ${__stream} | ${__current_version} | ${__latest_version} | ${metadata}"
        __container_versions+=("ci(release/${__app}/${__stream}): update container image from ${__current_version} to ${__latest_version}")
    fi
done

if [[ ${#__container_versions[@]} -gt 1 ]]; then
    #shellcheck disable=SC2028
    echo ::set-output name=commit-message::"ci(release/multiple): update container image versions\\n$(printf "%s\\\n" "${__container_versions[@]}")"
else
    echo ::set-output name=commit-message::"$(printf "%s" "${__container_versions[@]}")"
fi
