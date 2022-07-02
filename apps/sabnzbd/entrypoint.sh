#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"
test -f "/scripts/vpn.sh" && source "/scripts/vpn.sh"

if [[ ! -f "/config/sabnzbd.ini" ]]; then
    printf "Copying over default configuration ... "
    mkdir -p /config/sabnzbd
    cp /app/sabnzbd.ini /config/sabnzbd.ini

    if [[ -n "${SABNZBD__API_KEY}" ]]; then
        api_key="${SABNZBD__API_KEY}"
    else
        printf "Creating api key ..."
        api_key=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 32 | head -n 1)
    fi

    if [[ -n "${SABNZBD__NZB_KEY}" ]]; then
        nzb_key="${SABNZBD__NZB_KEY}"
    else
        printf "Creating nzb key ..."
        nzb_key=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 32 | head -n 1)
    fi

    sed -i -e "s/^api_key *=.*$/api_key = ${api_key}/g" /config/sabnzbd.ini
    sed -i -e "s/^nzb_key *=.*$/nzb_key = ${nzb_key}/g" /config/sabnzbd.ini
fi

if [[ -n ${SABNZBD__HOST_WHITELIST_ENTRIES} ]]; then
    printf "Updating host_whitelist setting ... "
    sed -i -e "s/^host_whitelist *=.*$/host_whitelist = ${HOSTNAME:-sabnzbd}, ${SABNZBD__HOST_WHITELIST_ENTRIES}/g" /config/sabnzbd.ini
fi

#shellcheck disable=SC2086
exec \
    /usr/bin/python3 \
        /app/SABnzbd.py \
        --browser 0 \
        --server 0.0.0.0:${SABNZBD__PORT:-8080} \
        --config-file /config/sabnzbd.ini \
        ${EXTRA_ARGS}
