#!/usr/bin/env bash
version=$(curl -sX GET "https://pkgs.alpinelinux.org/packages?name=rclone&branch=v3.16&arch" | grep -oP '(?<=<td class="version">)[^<]*')
version="${version%%_*}"
version="${version%%-*}"
printf "%s" "${version}"
