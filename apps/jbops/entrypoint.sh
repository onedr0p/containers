#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"

exec \
    /usr/bin/python3 \
        "/app/${JBOPS__SCRIPT_PATH}" \
        "$@"
