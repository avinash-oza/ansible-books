#!/bin/bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
    printf 'Usage: %s <start|finish|fail> <alert_slug>\n' "$0" >&2
    exit 1
fi

action="$1"
alert_slug="$2"

if [[ -z "$alert_slug" || "$alert_slug" == *[!a-zA-Z0-9_-]* ]]; then
    printf 'Error: alert_slug must contain only letters, numbers, underscores, or hyphens.\n' >&2
    exit 1
fi

url="https://hc-ping.com/{{ vault_healthchecks_io_key }}/${alert_slug}"

case "$action" in
    start|fail)
        url="${url}/${action}?create=1"
        ;;
    finish)
        ;;
    *)
        printf 'Error: first argument must be start, finish, or fail.\n' >&2
        exit 1
        ;;
esac

exec curl --fail --silent --show-error --output /dev/null -m 10 --retry 5 "$url"