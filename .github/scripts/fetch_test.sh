#!/usr/bin/env bash



shopt -s lastpipe

__container_versions=()
__changed_channels=()
find ./apps -name metadata.json5 | while read -r __metadata; do
    __app=$(echo "${__metadata}" | awk -F / '{print $3}')
    __script="$(dirname "${__metadata}")/latest-version.sh"    
    jq -c '.__channels | .[]' "${__metadata}" | while read -r __channels; do
        __name="$(jq --raw-output '.__name' <<< "${__channels}")"
        __version="$(jq --raw-output '.__version' <<< "${__channels}")"
        if test -f "${__script}"; then
            __fetched_version="$(bash "${__script}" "${__name}")"
            if [[ "${__fetched_version}" != "${__version}" ]]; then
                __container_versions+=("⚡ Fetched new version for ${__app}-${__channel} (${__version} → ${__fetched_version})")
            fi
            __changed_channels+=("$(jo \
                __app="${__app}" \
                __name="${__name}" \
                __fetched_version="${__fetched_version}" \
                __build_status="$(jo __success@1)")" \
            )
        fi
    done
    # Merge changed values back into original metadata
    if (( ${#__changed_channels[@]} )); then
        jo -a "${__changed_channels[@]}" | jq '{__channels: [(.[])]}' > /tmp/parsed.json
        spruce merge "${__metadata}" /tmp/parsed.json | spruce json | jq | sponge "${__metadata}"
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
