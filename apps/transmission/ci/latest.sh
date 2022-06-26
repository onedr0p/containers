#!/usr/bin/env bash
version=$(curl -sX GET "https://pkgs.alpinelinux.org/packages?name=transmission-daemon&branch=v3.16" | grep -oP '(?<=<td class="version">)[^<]*')
version="${version%%_*}"
version="${version%%-*}"
printf "%s" "${version}"
