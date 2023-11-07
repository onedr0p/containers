#!/usr/bin/env bash
set -e

args=()

if [ -z "$SEPARATOR" ]; then
    SEPARATOR=", "
fi

if [ -n "$CFG_ID" ]; then
    args+=('--id')
    args+=("$CFG_ID")
fi

if [ -n "$CFG_PORT" ]; then
    args+=('--port')
    args+=("$CFG_PORT")
fi

if [ -n "$CFG_DEV" ]; then
    IFS="${SEPARATOR}" read -r -a devices <<< "${CFG_DEV}"
    for element in "${devices[@]}"
    do
        args+=('--dev')
        args+=("$element")
    done
fi

if [ -n "$CFG_MULTICAST" ]; then
    args+=('--multicast')
    args+=("$CFG_MULTICAST")
fi

if [ -n "$CFG_SOURCE_IP" ]; then
    args+=('-s')
    args+=("$CFG_SOURCE_IP")
fi

if [ -n "$CFG_TARGET_IP" ]; then
    args+=('-t')
    args+=("$CFG_TARGET_IP")
fi

/app/udp-broadcast-relay-redux ${args[@]}
