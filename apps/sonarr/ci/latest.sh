#!/usr/bin/env bash
channel=$1

if [[ "${channel}" == "widowmaker" ]]; then
    version=$(curl -sX GET "https://sonarr.servarr.com/v1/update/${channel}/changes?os=linux&runtime=netcore" | jq --raw-output '.[0].version')
else
    version=$(curl -sX GET "https://services.sonarr.tv/v1/download/${channel}?version=3" | jq --raw-output '.version')
fi

version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
