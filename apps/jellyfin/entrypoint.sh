#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"
test -f "/scripts/vpn.sh" && source "/scripts/vpn.sh"

#shellcheck disable=SC2086
exec \
    /usr/bin/jellyfin \
        --ffmpeg="/usr/lib/jellyfin-ffmpeg/ffmpeg" \
        --webdir="/usr/share/jellyfin/web" \
        --datadir="/config" \
        --cachedir="/config/cache" \
        ${EXTRA_ARGS}
