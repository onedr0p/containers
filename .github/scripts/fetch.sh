#!/usr/bin/env bash

shopt -s lastpipe

__container_versions=()
find . -name metadata.json | while read -r metadata; do
    __app=$(echo "${metadata}" | awk -F / '{print $3}')
    __current_version=$(jq --raw-output ".__current_version" "${metadata}")
    __stream=$(echo "${metadata}" | awk -F / '{print $4}')
    __latest_version="$(bash "$(dirname "$(dirname "${metadata}")")"/latest-version.sh "${__stream}")"
    __script="$(dirname "$(dirname "${metadata}")")/latest-version.sh)"
    if test -f "${__script}"; then
        if [[ -n "${__latest_version}" || "${__latest_version}" != "null" ]]; then
            jq --arg v "$__latest_version" '.__current_version = $v' "${metadata}" | sponge "${metadata}"
            jq '.__build_status.__success = true' "${metadata}" | sponge "${metadata}"
            echo "${__app} | ${__stream} | ${__current_version} | ${__latest_version} | ${metadata}"
            if [[ "${__latest_version}" !=  "${__current_version}" ]]; then
                __container_versions+=("⚡ Fetched new version for ${__app}-${__stream} (${__current_version} → ${__latest_version})")
            fi
        fi
    fi
done

COMMIT_MESSAGE="$(printf "%s" "${__container_versions[@]}")"
if [[ ${#__container_versions[@]} -gt 1 ]]; then
COMMIT_MESSAGE="⚡ Fetched new versions for multiple applications"
COMMIT_MESSAGE=$(cat << EOF
${COMMIT_MESSAGE}
$(printf "%s\n" "${__container_versions[@]}")
EOF
)
fi

COMMIT_MESSAGE="${COMMIT_MESSAGE//'%'/'%25'}"
COMMIT_MESSAGE="${COMMIT_MESSAGE//$'\n'/'%0A'}"
COMMIT_MESSAGE="${COMMIT_MESSAGE//$'\r'/'%0D'}"

echo "::set-output name=commit-message::${COMMIT_MESSAGE}"
