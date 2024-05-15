#!/usr/bin/env bash

if [[ ! -f "/config/ntp.toml" ]]; then
    printf "Copying over default configuration ...\n"
    cp /etc/ntpd-rs/ntp.toml /config/ntp.toml
fi

#shellcheck disable=SC2086
exec \
    /usr/local/bin/ntp-daemon \
        --config /config/ntp.toml \
        --log-level debug
