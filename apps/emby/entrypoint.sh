#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"
test -f "/scripts/vpn.sh" && source "/scripts/vpn.sh"

APP_DIR="/app/emby"
export LD_LIBRARY_PATH="${APP_DIR}"
export FONTCONFIG_PATH="${APP_DIR}/etc/fonts"
if [ -d "/lib/x86_64-linux-gnu" ]; then
	export LIBVA_DRIVERS_PATH="/usr/lib/x86_64-linux-gnu/dri:${APP_DIR}/dri"
fi
export SSL_CERT_FILE="${APP_DIR}/etc/ssl/certs/ca-certificates.crt"

exec /app/emby/EmbyServer \
	-programdata /config \
	-ffdetect /app/emby/ffdetect \
	-ffmpeg /app/emby/ffmpeg \
	-ffprobe /app/emby/ffprobe \
	-restartexitcode 3
