#!/usr/bin/env bash

shopt -s lastpipe

__changed_channels=()
__app=$(echo "${{ matrix.apps }}" | awk -F / '{print $2}')
jq -c '.__channels | .[]' "${{ matrix.apps }}" | while read -r __channels; do
    __name="$(jq --raw-output '.__name' <<< "${__channels}")"
    __version="$(jq --raw-output '.__version' <<< "${__channels}")"
    __fetched_version="$(jq --raw-output '.__fetched_version' <<< "${__channels}")"
    if [[ "${__fetched_version}" != "${__version}" ]]; then
        __changed_channels+=("${__app}/${__name}")
    fi
done

# if (( ${#__changed_channels[@]} )); then
#     __channels="$(jo -a "${__changed_channels[@]}" | jq --raw-output)"
# fi

echo "::set-output name=apps::$(jo -a "${__app}" | jq --raw-output)"
echo "::set-output name=channels::$(jo -a "${__changed_channels[@]}" | jq --raw-output)"
