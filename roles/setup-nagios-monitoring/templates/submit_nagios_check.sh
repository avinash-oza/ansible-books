# requires SERVICE_NAME and CHECK_CMD
CMD_OUTPUT="$(/usr/lib/nagios/plugins/"$CHECK_CMD")"

/usr/local/nrdp/clients/send_nrdp.sh -u {{ vault_nagios_submit_passive_check_url }} -t {{ vault_nagios_passive_checks_api_key }} -H {{ nagios_host_name }} -s "$SERVICE_NAME" -S "$?" -o "$CMD_OUTPUT"
