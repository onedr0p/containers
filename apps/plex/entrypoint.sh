#!/usr/bin/env bash

#shellcheck disable=SC1091
source "/hack/umask.sh"
source "/hack/vpn.sh"
source "/hack/plex-preferences.sh"

#shellcheck disable=SC2155
export PLEX_MEDIA_SERVER_INFO_MODEL=$(uname -m)
#shellcheck disable=SC2155
export PLEX_MEDIA_SERVER_INFO_PLATFORM_VERSION=$(uname -r)

[[ -f "${PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR}/Plex Media Server/plexmediaserver.pid" ]] && \
    rm -f "${PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR}/Plex Media Server/plexmediaserver.pid"

exec /usr/lib/plexmediaserver/Plex\ Media\ Server
