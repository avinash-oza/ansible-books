#!/bin/bash
set -euo pipefail

# db-backup wrapper script for healthchecks.io integration
# Environment variables:
#   DBB_TYPE            - Database type (required)
#   DBB_HOST            - Database host (required)
#   DBB_NAME            - Database name (required)
#   DBB_FILENAME        - Backup filename (required)

backup_type="${DBB_TYPE:-}"
backup_host="${DBB_HOST:-}"
backup_name="${DBB_NAME:-}"
backup_filename="${DBB_FILENAME:-}"

if [[ -z "$backup_type" || -z "$backup_host" || -z "$backup_name" ]]; then
    printf 'Error: DBB_TYPE, DBB_HOST, and DBB_NAME must not be empty.\n' >&2
    exit 1
fi

if [[ -z "$backup_filename" ]]; then
    printf 'Error: DBB_FILENAME must not be empty.\n' >&2
    exit 1
fi

printf '%s Backup Finished on %s for %s. Filename: %s.\n' \
    "$backup_type" "$backup_host" "$backup_name" "$backup_filename"

exec bash /assets/scripts/send-healthchecks-io.sh finish "db-backup-${backup_host}-${backup_type}-${backup_name}"
