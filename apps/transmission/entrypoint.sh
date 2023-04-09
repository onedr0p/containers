#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"
test -f "/scripts/vpn.sh" && source "/scripts/vpn.sh"

# Update settings.json with environment variables
envsubst < /app/settings.json.tmpl > /config/settings.json

if [[ "${TRANSMISSION__DEBUG}" == "true" ]]; then
    echo "Transmission starting with the following configuration..."
    cat /config/settings.json
fi

#shellcheck disable=SC2086
exec \
    /app/transmission-daemon \
        --foreground \
        --config-dir /config \
        --port "${TRANSMISSION__RPC_PORT:-9091}" \
        "$@"
