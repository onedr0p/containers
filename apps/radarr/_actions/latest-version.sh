#!/usr/bin/env bash
stream=$1
version=$(curl -sX GET "https://radarr.servarr.com/v1/update/${stream}/changes?os=linux&runtime=netcore" | jq --raw-output '.[0].version')
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
