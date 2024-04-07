#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"

#shellcheck disable=SC2086
exec \
    python \
        /app/Tautulli.py \
        --nolaunch \
        --config /config/config.ini \
        --datadir /config \
        "$@"
