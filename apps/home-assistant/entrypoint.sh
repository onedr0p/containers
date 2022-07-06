#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"
test -f "/scripts/vpn.sh" && source "/scripts/vpn.sh"

if [[ "${HOME_ASSISTANT__HACS_INSTALL}" == "true" ]]; then
    wget -O - https://get.hacs.xyz | bash -
fi

exec \
    /usr/bin/hass \
        -c /config \
        "$@"
