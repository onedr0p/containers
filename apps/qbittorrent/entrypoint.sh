#!/usr/bin/env bash
#shellcheck disable=SC2086,SC2090

CONFIG_FILE="/config/qBittorrent/qBittorrent.conf"
LOG_FILE="/config/qBittorrent/logs/qbittorrent.log"

export QBT_WEBUI_PORT=${QBITTORRENT__PORT:-$QBT_WEBUI_PORT} # QBITTORRENT__PORT is deprecated
export QBT_TORRENTING_PORT=${QBITTORRENT__BT_PORT:-$QBT_TORRENTING_PORT} # QBITTORRENT__BT_PORT is deprecated

if [[ ! -f "${CONFIG_FILE}" ]]; then
    printf "Copying over default configuration ...\n"
    mkdir -p "$(dirname ${CONFIG_FILE})"
    cp /app/qBittorrent.conf "${CONFIG_FILE}"
fi

# Set up log file to redirect to stdout
if [[ ! -f "${LOG_FILE}" ]]; then
    mkdir -p "$(dirname ${LOG_FILE})"
    ln -sf /proc/self/fd/1 "${LOG_FILE}"
fi

exec /app/qbittorrent-nox "$@"
