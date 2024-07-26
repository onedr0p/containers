#!/usr/bin/env bash

set -e

CFG_FILE="/config/config.xml"
CFG_FILE_BAK="$(mktemp -u "$CFG_FILE.bak.XXXXXX")"

if [ -f "$CFG_FILE" ]; then
    # Preserve old configuration, in case of ENOSPC or other errors
    cp -f "$CFG_FILE" "$CFG_FILE_BAK" || (echo "Error: Could not backup config file" >&2; exit 99)
fi

getOpt() {
    xmlstarlet sel -t -c /Config/"$1" "$CFG_FILE"
}

setOpt() {
    # If element exists
    if xmlstarlet sel -Q -t -c "/Config/$1" "$CFG_FILE"; then
        # Update the existing element
        xmlstarlet ed -O -L -u "/Config/$1" -v "$2" "$CFG_FILE"
    else
        # Insert a new sub-element
        xmlstarlet ed -O -L -s /Config -t elem -n "$1" -v "$2" "$CFG_FILE"
    fi
}

bool() {
    local var="$(echo "$1" | tr 'A-Z' 'a-z')"
    case "$var" in
        y|ye|yes|t|tr|tru|true|1)
            echo True;;
        n|no|f|fa|fal|fals|false|0)
            echo False;;
    esac
}

upper() { echo $1 | awk '{print toupper($0)}'; }
lower() { echo $1 | awk '{print tolower($0)}'; }
camel() { echo $1 | awk '{print toupper(substr($1,1,1)) tolower(substr($1,2))}'; }

# Create config.xml file and fill in some sane defaults (or fill existing empty file)

if [ ! -f "$CFG_FILE" ] || [ ! -s "$CFG_FILE" ]; then
    (echo '<Config>'; echo '</Config>') > "$CFG_FILE"
    setOpt AnalyticsEnabled False
    setOpt BindAddress '*'
    setOpt EnableSsl False
    setOpt LaunchBrowser False
    setOpt LogLevel 'info'
fi

# If they exist, add options that are specified in the environment
[ -n "$LIDARR_API_KEY" ]    && setOpt ApiKey $(lower "$LIDARR_API_KEY")
[ -n "$LIDARR_ANALYTICS" ]  && setOpt AnalyticsEnabled $(bool "${LIDARR_ANALYTICS:-false}")
[ -n "$LIDARR_LOG_LEVEL" ]  && setOpt LogLevel $(camel "${LIDARR_LOG_LEVEL:-info}")
[ -n "$LIDARR_URL_BASE" ]   && setOpt UrlBase "$LIDARR_URL_BASE"

# Postgres
[ -n "$LIDARR_POSTGRES_USER" ]    && setOpt PostgresUser "$LIDARR_POSTGRES_USER"
[ -n "$LIDARR_POSTGRES_PASS" ]    && setOpt PostgresUser "$LIDARR_POSTGRES_PASSWORD"
[ -n "$LIDARR_POSTGRES_PORT" ]    && setOpt PostgresPort "${LIDARR_POSTGRES_PORT:-5432}"
[ -n "$LIDARR_POSTGRES_MAIN_DB" ] && setOpt PostgresMainDb "$LIDARR_POSTGRES_MAIN_DB"
[ -n "$LIDARR_POSTGRES_LOG_DB" ]  && setOpt PostgresLogDb "$LIDARR_POSTGRES_LOG_DB"

# Remove backup file. if it reached here, config was set correctly.
rm -f "$CFG_FILE_BAK"

#shellcheck disable=SC2086
exec \
    /app/bin/Lidarr \
        --nobrowser \
        --data=/config \
        "$@"
