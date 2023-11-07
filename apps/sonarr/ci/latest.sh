#!/usr/bin/env bash
channel=$1

if [[ "${channel}" == "develop" ]]; then
    version=$(curl -sX GET "https://services.sonarr.tv/v1/download/${channel}?version=4.0" | jq --raw-output '.version' 2>/dev/null)
else
    version=$(curl -sX GET "https://services.sonarr.tv/v1/download/${channel}?version=3" | jq --raw-output '.version' 2>/dev/null)
fi

version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
