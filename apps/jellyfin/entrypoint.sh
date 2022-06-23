#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"
test -f "/scripts/vpn.sh" && source "/scripts/vpn.sh"

[[ -z ${JELLYFIN_CONFIG_DIR} ]] && JELLYFIN_CONFIG_DIR="${CONFIG_DIR}" && export JELLYFIN_CONFIG_DIR
[[ -z ${JELLYFIN_DATA_DIR} ]] && JELLYFIN_DATA_DIR="${CONFIG_DIR}/data" && export JELLYFIN_DATA_DIR
[[ -z ${JELLYFIN_LOG_DIR} ]] && JELLYFIN_LOG_DIR="${CONFIG_DIR}/log" && export JELLYFIN_LOG_DIR
[[ -z ${JELLYFIN_CACHE_DIR} ]] && JELLYFIN_CACHE_DIR="${CONFIG_DIR}/cache" && export JELLYFIN_CACHE_DIR

exec /usr/bin/jellyfin --ffmpeg="/usr/lib/jellyfin-ffmpeg/ffmpeg" --webdir="/usr/share/jellyfin/web"
