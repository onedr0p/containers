#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"
test -f "/scripts/vpn.sh" && source "/scripts/vpn.sh"

if [[ ! -f "/config/nzbget.conf" ]]; then
    cp /app/nzbget.conf /config/nzbget.conf
    sed -i \
        -e "s#\\(MainDir=\\).*#\\1/config/downloads#g" \
        -e "s#\\(QueueDir=\\).*#\\1/config/queue#g" \
        -e "s#\\(LockFile=\\).*#\\1/config/nzbget.lock#g" \
        -e "s#\\(LogFile=\\).*#\\1/config/nzbget.log#g" \
        -e "s#\\(ShellOverride=\\).*#\\1.py=/usr/bin/python3#g" \
        "/config/nzbget.conf"
fi

#shellcheck disable=SC2086
exec \
    /app/nzbget \
        --server \
        --option "OutputMode=log" \
        --configfile /config/nzbget.conf \
        "$@"
