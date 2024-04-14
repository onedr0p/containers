#!/usr/bin/env bash

#shellcheck disable=SC2086
exec \
    /usr/local/bin/python \
        /app/bazarr.py \
            --no-update \
            --config /config \
            --port ${BAZARR__PORT:-6767} \
            "$@"
