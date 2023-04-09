#!/usr/bin/env bash
#version=$(curl -sX GET "https://pkgs.alpinelinux.org/packages?name=transmission-daemon&branch=v3.17" | grep -oP '(?<=<td class="version">)[^<]*' 2>/dev/null)
version=$(curl -sX GET "https://repology.org/api/v1/projects/?search=transmission&inrepo=alpine_edge" | jq -r '.transmission | .[] | select((.repo == "alpine_edge" and .binname == "transmission-daemon")) | .origversion')
version="${version%%_*}"
version="${version%%-*}"
printf "%s" "${version}"