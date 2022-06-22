#!/usr/bin/env bash
stream=$1
version=$(curl -s "https://registry.hub.docker.com/v1/repositories/library/ubuntu/tags" | jq --raw-output --arg s "$stream" '.[] | select(.name | contains($s)) | .name'  | tail -n1)
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
