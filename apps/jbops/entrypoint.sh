#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"
test -f "/scripts/vpn.sh" && source "/scripts/vpn.sh"

if [[ ! -f /config/config.ini ]]; then
    cp /app/config.ini /config/config.ini
fi

#shellcheck disable=SC2086
exec \
    /usr/bin/python3 \
        /app/${JBOPS__SCRIPT_PATH} \
        ${EXTRA_ARGS}
