#!/bin/bash
set -euo pipefail

# db-backup wrapper script for healthchecks.io integration

if [[ $# -ne 5 ]]; then
    printf 'Usage: %s <DB01_TYPE> <DB01_HOST> <DB01_NAME> <BACKUP_START_TIME> <BACKUP_FILENAME>\n' "$0" >&2
    exit 1
fi

backup_type="$1"
backup_host="$2"
backup_name="$3"

if [[ -z "$backup_type" || -z "$backup_host" || -z "$backup_name" ]]; then
    printf 'Error: DB01_TYPE, DB01_HOST, and DB01_NAME must not be empty.\n' >&2
    exit 1
fi

echo "${1} Backup Starting on ${2} for ${3} at ${4}. Filename: ${5}"

exec bash /assets/scripts/send-healthchecks-io.sh start "db-backup-${backup_host}-${backup_type}-${backup_name}"
