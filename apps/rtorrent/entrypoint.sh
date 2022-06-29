#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"
test -f "/scripts/vpn.sh" && source "/scripts/vpn.sh"

if [[ ! -f "/config/rtorrent.rc" ]]; then
    cp /app/rtorrent.rc /config/rtorrent.rc
fi

#shellcheck disable=SC2086
exec \
    /app/rtorrent \
        -n -o "try_import=/config/rtorrent.rc,network.port_range.set=${RTORRENT_BITTORRENT_PORT}-${RTORRENT_BITTORRENT_PORT},network.scgi.open_local=/dev/shm/rtorrent.sock,system.daemon.set=true" \
        ${EXTRA_ARGS}
