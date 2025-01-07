#!/usr/bin/env bash
version=$(curl -sL "https://github.com/userdocs/qbittorrent-nox-static/releases/latest/download/dependency-version.json" | jq -r '. | "release-\(.qbittorrent)_v\(.libtorrent_2_0)"' 2>/dev/null)
version="${version#*release-}"
version="${version%%_*}"
printf "%s" "${version}"
