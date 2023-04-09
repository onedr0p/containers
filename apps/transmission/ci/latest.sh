#!/usr/bin/env bash
version=$(curl -sX GET "https://repology.org/api/v1/projects/?search=transmission&inrepo=alpine_edge" | jq -r '.transmission | .[] | select((.repo == "alpine_edge" and .binname == "transmission-daemon")) | .origversion')
version="${version%%_*}"
version="${version%%-*}"
printf "%s" "${version}"
