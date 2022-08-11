#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"

#shellcheck disable=SC2086
exec \
    /usr/bin/python3 \
        /app/nzbhydra2wrapperPy3.py \
            --nobrowser \
            --datafolder /config \
            "$@"
