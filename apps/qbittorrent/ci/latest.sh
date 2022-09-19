#!/usr/bin/env bash
# version=$(curl -sX GET "https://pkgs.alpinelinux.org/packages?name=qbittorrent-nox&branch=v3.16&arch" | grep -oP '(?<=<td class="version">)[^<]*')
version=$(curl -sX GET "https://repology.org/api/v1/projects/?search=qbittorrent&inrepo=alpine_edge" | jq -r '.qbittorrent | .[] | select((.repo == "alpine_edge" and .binname == "qbittorrent-nox")) | .version')
version="${version%%_*}"
version="${version%%-*}"
printf "%s" "${version}"
