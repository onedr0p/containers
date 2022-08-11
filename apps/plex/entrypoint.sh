#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"
test -f "/scripts/plex-preferences.sh" && source "/scripts/plex-preferences.sh"

#shellcheck disable=SC2155
export PLEX_MEDIA_SERVER_INFO_MODEL=$(uname -m)
#shellcheck disable=SC2155
export PLEX_MEDIA_SERVER_INFO_PLATFORM_VERSION=$(uname -r)

[[ -f "${PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR}/Plex Media Server/plexmediaserver.pid" ]] && \
    rm -f "${PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR}/Plex Media Server/plexmediaserver.pid"

#shellcheck disable=SC2086
exec \
    /usr/lib/plexmediaserver/Plex\ Media\ Server \
    "$@"
