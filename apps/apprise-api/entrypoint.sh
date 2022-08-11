#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"

exec \
    /usr/sbin/uwsgi \
        --chdir=/app/apprise_api \
        --http-socket=:8000 \
        --enable-threads \
        --plugin=python3 \
        --module=core.wsgi:application \
        --static-map=/s=static \
        --buffer-size=32768 \
        "$@"
