#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"

printf "Kubernetes Sidecar Container Backup\n"
printf "%-35s\n" " " | tr ' ~' '- '
printf "%-13s%s\n" "SOURCE:~" "~$KSCB__SOURCE" | tr ' ~' '  '
printf "%-13s%s\n" "DESTINATION:~" "~$KSCB__DESTINATION" | tr ' ~' '  '
printf "%-13s%s\n" "SCHEDULE:~" "~$KSCB__SCHEDULE" | tr ' ~' '  '
printf "\n"

exec /usr/local/bin/go-cron -s "$KSCB__SCHEDULE" -p "$KSCB__HEALTHCHECK_PORT" -- /app/backup.sh
