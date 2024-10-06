#!/usr/bin/env bash
#shellcheck disable=SC2086

set -euo pipefail

# Function to update the sabnzbd.ini file
update_config() {
    local key=$1
    local value=$2
    sed -i -e "s/^${key} *=.*$/${key} = ${value}/g" /config/sabnzbd.ini
}

if [[ ! -f "/config/sabnzbd.ini" ]]; then
    printf "Copying over default configuration ...\n"
    mkdir -p /config/sabnzbd
    cp /app/sabnzbd.ini /config/sabnzbd.ini

    printf "Creating api keys ...\n"
    api_key=$(tr -dc 'a-z0-9' < /dev/urandom | fold -w 32 | head -n 1)
    nzb_key=$(tr -dc 'a-z0-9' < /dev/urandom | fold -w 32 | head -n 1)

    update_config "api_key" "${api_key}"
    update_config "nzb_key" "${nzb_key}"
fi

[[ -n "${SABNZBD__API_KEY:-}" ]] && update_config "api_key" "${SABNZBD__API_KEY}"
[[ -n "${SABNZBD__NZB_KEY:-}" ]] && update_config "nzb_key" "${SABNZBD__NZB_KEY}"

if [[ -n "${SABNZBD__HOST_WHITELIST_ENTRIES:-}" ]]; then
    update_config "host_whitelist" "${HOSTNAME:-sabnzbd}, ${SABNZBD__HOST_WHITELIST_ENTRIES}"
fi

exec \
    /usr/local/bin/python \
        /app/SABnzbd.py \
        --browser 0 \
        --server "${SABNZBD__ADDRESS}:${SABNZBD__PORT}" \
        --config-file /config/sabnzbd.ini \
        --disable-file-log \
        --console \
        "$@"
