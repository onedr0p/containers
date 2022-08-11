#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"

#shellcheck disable=SC2086
exec \
    /app/Ombi \
        --host http://0.0.0.0:5000 \
        --storage /config \
        "$@"
