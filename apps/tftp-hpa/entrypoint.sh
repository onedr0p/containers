#!/usr/bin/env bash

exec /usr/sbin/in.tftpd \
    --foreground \
    --verbose \
    --secure \
    --user tftpd \
    /config
