# requires SERVICE_NAME
# specify CHECK_SCRIPT/CHECK_ARGS if an external script produces the output
# otherwise CHECK_CMD/CHECK_ARGS should be nagios plugins

# use CMD if defined else fall back to standard nagios plugins
if [ ! -z ${CHECK_SCRIPT+x} ];
then CMD_OUTPUT="$($CHECK_SCRIPT $CHECK_ARGS)";
else CMD_OUTPUT="$(/usr/lib/nagios/plugins/"$CHECK_CMD" $CHECK_ARGS)";
fi

{{ scripts_dir }}/send_nrdp.sh -u {{ vault_nagios_submit_passive_check_url }} -t {{ vault_nagios_passive_checks_api_key }} -H {{ nagios_host_name }} -s "$SERVICE_NAME" -S "$?" -o "$CMD_OUTPUT"
