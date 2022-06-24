#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"
test -f "/scripts/vpn.sh" && source "/scripts/vpn.sh"

exec \
    /usr/bin/python3 \
        /app/nzbhydra2wrapperPy3.py \
            --nobrowser \
            --datafolder /config \
            ${EXTRA_ARGS}
