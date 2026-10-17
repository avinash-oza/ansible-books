#!/bin/bash
set -euo pipefail

# db-backup wrapper script for healthchecks.io integration

if [[ $# -ne 11 ]]; then
    printf 'Usage: %s <EXIT_CODE> <DB_TYPE> <DB_HOST> <DB_NAME> <BACKUP_START_TIME> <BACKUP_FINISH_TIME> <BACKUP_TOTAL_TIME> <BACKUP_FILENAME> <BACKUP_FILESIZE> <HASH> <MOVE_EXIT_CODE>\n' "$0" >&2
    exit 1
fi

backup_type="$2"
backup_host="$3"
backup_name="$4"

if [[ -z "$backup_type" || -z "$backup_host" || -z "$backup_name" ]]; then
    printf 'Error: DB_TYPE, DB_HOST, and DB_NAME must not be empty.\n' >&2
    exit 1
fi

printf '%s Backup Finished on %s for %s. Started at %s. Finished at %s. Total time: %s seconds. Filename: %s. Filesize: %s. Hash: %s. Exit code: %s. Move exit code: %s.\n' \
    "$backup_type" "$backup_host" "$4" "$5" "$6" "$7" "$8" "$9" "${10}" "$1" "${11}"

action="finish"
if [[ "$1" != "0" ]]; then
    action="fail"
fi

exec bash /assets/scripts/send-healthchecks-io.sh "$action" "db-backup-${backup_host}-${backup_type}-${backup_name}"
