#!/usr/bin/env bash
channel=$1

if [[ "${channel}" == "stable" ]]; then
    version=$(curl -sX GET 'https://plex.tv/api/downloads/5.json' | jq -r '.computer.Linux.version')
fi

version="${version#*v}"
version="${version#*release-}"

printf "%s" "${version}"
