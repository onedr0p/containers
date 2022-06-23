#!/usr/bin/env bash

shopt -s lastpipe

__changed_channels=()
jq -c '.__channels | .[]' "apps/lidarr/metadata.json5" | while read -r __channels; do
    __app=$(echo "apps/lidarr/metadata.json5" | awk -F / '{print $2}')
    __name="$(jq --raw-output '.__name' <<< "${__channels}")"
    __version="$(jq --raw-output '.__version' <<< "${__channels}")"
    __fetched_version="$(jq --raw-output '.__fetched_version' <<< "${__channels}")"
    if [[ "${__fetched_version}" != "${__version}" ]]; then
        __changed_channels+=("${__app}/${__name}")
    fi
done

if (( ${#__changed_channels[@]} )); then
    channels="$(jo -a "${__changed_channels[@]}" | jq --raw-output)"
fi

echo "::set-output name=channels::${channels}"
