#!/usr/bin/env bash
channel=$1
version=$(curl -s "https://registry.hub.docker.com/v1/repositories/library/alpine/tags" | jq --raw-output --arg s "$channel" '.[] | select(.name | contains($s)) | .name'  | tail -n1)
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
