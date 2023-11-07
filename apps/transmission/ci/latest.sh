#!/usr/bin/env bash
version=$(curl -sX GET "https://repology.org/api/v1/projects/?search=transmission&inrepo=alpine_3_18" | jq -r '.transmission | .[] | select((.repo == "alpine_3_18" and .binname == "transmission-daemon")) | .origversion')
version="${version%%_*}"
version="${version%%-*}"
printf "%s" "${version}"
