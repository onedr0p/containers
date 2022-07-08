#!/usr/bin/env bash
set -eo pipefail

log() {
  printf "%s %s\n" "$1" "$2"
}

#Process vars
if [ "${KSCB__SOURCE}" = "**None**" ]; then
  log "ERROR" "You need to set the KSCB__SOURCE environment variable."
  exit 1
fi

if [ "${KSCB__DESTINATION}" = "**None**" ]; then
  log "ERROR" "You need to set the KSCB__DESTINATION environment variable."
  exit 1
fi

if [[ ! -d "${KSCB__SOURCE}" ]]; then
  echo "${KSCB__SOURCE} is not a folder."
  exit 1
fi

if [[ ! -d "${KSCB__DESTINATION}" ]]; then
  echo "${KSCB__DESTINATION} is not a folder."
  exit 1
fi

KEEP_MINS=${KSCB__KEEP_MINS}
KEEP_DAYS=${KSCB__KEEP_DAYS}
KEEP_WEEKS=$(((KSCB__KEEP_WEEKS * 7) + 1))
KEEP_MONTHS=$(((KSCB__KEEP_MONTHS * 31) + 1))
BACKUP_SUFFIX=".tar.gz"

#Initialize dirs
mkdir -p "${KSCB__DESTINATION}/last/" "${KSCB__DESTINATION}/daily/" "${KSCB__DESTINATION}/weekly/" "${KSCB__DESTINATION}/monthly/"

#Initialize filename vers
LAST_FILENAME="$(printf "%s%s" "$(date "+%Y%m%d-%H%M%S")" "${BACKUP_SUFFIX}")"
DAILY_FILENAME="$(printf "%s%s" "$(date "+%Y%m%d")" "${BACKUP_SUFFIX}")"
WEEKLY_FILENAME="$(printf "%s%s" "$(date "+%G%V")" "${BACKUP_SUFFIX}")"
MONTHY_FILENAME="$(printf "%s%s" "$(date "+%Y%m")" "${BACKUP_SUFFIX}")"
FILE="${KSCB__DESTINATION}/last/${LAST_FILENAME}"
DFILE="${KSCB__DESTINATION}/daily/${DAILY_FILENAME}"
WFILE="${KSCB__DESTINATION}/weekly/${WEEKLY_FILENAME}"
MFILE="${KSCB__DESTINATION}/monthly/${MONTHY_FILENAME}"

#Create backup
log "INFO" "Backing up ${KSCB__SOURCE} contents to ${FILE}"
tar -zcf "${FILE}" -C "${KSCB__SOURCE}" .

#Copy (hardlink) for each entry
if [ -d "${FILE}" ]; then
  DFILENEW="${DFILE}-new"
  WFILENEW="${WFILE}-new"
  MFILENEW="${MFILE}-new"
  rm -rf "${DFILENEW}" "${WFILENEW}" "${MFILENEW}"
  mkdir "${DFILENEW}" "${WFILENEW}" "${MFILENEW}"
  ln -f "${FILE}/"* "${DFILENEW}/"
  ln -f "${FILE}/"* "${WFILENEW}/"
  ln -f "${FILE}/"* "${MFILENEW}/"
  rm -rf "${DFILE}" "${WFILE}" "${MFILE}"
  mv -v "${DFILENEW}" "${DFILE}"
  mv -v "${WFILENEW}" "${WFILE}"
  mv -v "${MFILENEW}" "${MFILE}"
else
  ln -f "${FILE}" "${DFILE}"
  ln -f "${FILE}" "${WFILE}"
  ln -f "${FILE}" "${MFILE}"
fi

# Update latest symlinks
ln -sf "${LAST_FILENAME}" "${KSCB__DESTINATION}/last/latest${BACKUP_SUFFIX}"
ln -sf "${DAILY_FILENAME}" "${KSCB__DESTINATION}/daily/latest${BACKUP_SUFFIX}"
ln -sf "${WEEKLY_FILENAME}" "${KSCB__DESTINATION}/weekly/latest${BACKUP_SUFFIX}"
ln -sf "${MONTHY_FILENAME}" "${KSCB__DESTINATION}/monthly/latest${BACKUP_SUFFIX}"

#Clean old files
log "INFO" "Cleaning older files from ${KSCB__DESTINATION}..."
find "${KSCB__DESTINATION}/last" -maxdepth 1 -mmin "+${KEEP_MINS}" -name "*${BACKUP_SUFFIX}" -exec rm -rf '{}' ';'
find "${KSCB__DESTINATION}/daily" -maxdepth 1 -mtime "+${KEEP_DAYS}" -name "*${BACKUP_SUFFIX}" -exec rm -rf '{}' ';'
find "${KSCB__DESTINATION}/weekly" -maxdepth 1 -mtime "+${KEEP_WEEKS}" -name "*${BACKUP_SUFFIX}" -exec rm -rf '{}' ';'
find "${KSCB__DESTINATION}/monthly" -maxdepth 1 -mtime "+${KEEP_MONTHS}" -name "*${BACKUP_SUFFIX}" -exec rm -rf '{}' ';'
