#!/usr/bin/env bash
stream=$1

if [[ "${stream}" == "beta" ]]; then
    rm -rf plex-media-server-plexpass
    git clone --quiet --depth=1 https://aur.archlinux.org/plex-media-server-plexpass.git
    version="$(grep -oP "(?<=pkgver=).*" ./plex-media-server-plexpass/PKGBUILD)"
    version="${version}-$(grep -oP "(?<=_pkgsum=).*" ./plex-media-server-plexpass/PKGBUILD)"
    version="${version#*v}"
    version="${version#*release-}"
    printf "%s" "${version}"
    rm -rf plex-media-server-plexpass
fi

if [[ "${stream}" == "stable" ]]; then
    version=$(curl -sX GET 'https://plex.tv/api/downloads/5.json' | jq -r '.computer.Linux.version')
    version="${version#*v}"
    version="${version#*release-}"
    printf "%s" "${version}"
fi
