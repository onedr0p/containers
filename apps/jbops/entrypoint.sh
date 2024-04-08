#!/usr/bin/env bash

exec \
    /usr/bin/python3 \
        "/app/${JBOPS__SCRIPT_PATH}" \
        "$@"
