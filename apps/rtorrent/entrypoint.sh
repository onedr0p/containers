#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"
test -f "/scripts/vpn.sh" && source "/scripts/vpn.sh"

if [[ "${RTORRENT__DEFAULT_CONFIG}" == "true" && ! -f "${RTORRENT__CONFIG_FILE}" ]]; then
    cp /app/rtorrent.rc "${RTORRENT__CONFIG_FILE}"
fi

args+=("try_import=${RTORRENT__CONFIG_FILE}")
args+=("system.daemon.set=true")
args+=("encoding.add=utf8")
args+=("system.umask.set=0002")
args+=("session.use_lock.set=no")
args+=("network.scgi.open_local=${RTORRENT__SOCKET}")
args+=("network.port_range.set=${RTORRENT__BT_PORT}-${RTORRENT__BT_PORT}")

printf -v joined_args "%s," "${args[@]}"

#shellcheck disable=SC2086
exec \
    /app/rtorrent \
        -n \
        -o "${joined_args%,}" \
        "$@"
