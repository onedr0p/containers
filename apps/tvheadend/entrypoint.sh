#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"

mkdir -p /config/comskip

[[ ! -f /config/dvr/config ]] && \
	(mkdir -p /config/dvr/config && cp /app/defaults/7a5edfbe189851e5b1d1df19c93962f0 /config/dvr/config/7a5edfbe189851e5b1d1df19c93962f0)
[[ ! -f /config/comskip/comskip.ini ]] && \
    (cp /app/defaults/comskip.ini.org /config/comskip/comskip.ini)
[[ ! -f /config/config ]] && \
    (cp /app/defaults/config /config/config)

#shellcheck disable=SC2086
exec \
    /usr/bin/tvheadend -C \
        -c /config \
        "$@"
