#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"
test -f "/scripts/vpn.sh" && source "/scripts/vpn.sh"

#shellcheck disable=SC2086
exec \
    /app/flood \
        --rundir /config \
        --allowedpath /config \
        --allowedpath /dev/shm \
        --host 0.0.0.0 \
        --port 3001
        ${EXTRA_ARGS}
