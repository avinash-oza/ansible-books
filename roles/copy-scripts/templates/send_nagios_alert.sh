#!/bin/bash -e

export MSG=""
export AWS_ACCESS_KEY_ID={{ vault_aws_keys['nagios-sns'].key_id }}
export AWS_SECRET_ACCESS_KEY={{ vault_aws_keys['nagios-sns'].access_key }}
export TOPIC_ARN={{ vault_nagios_alert_sns_endpoint }}
export AWS_DEFAULT_REGION={{ vault_aws_default_region }}

# service
if [ $# -gt 0 ]; then
    MSG=$(cat <<END
*****Nagios*****
Notification Type: ${NAGIOS_NOTIFICATIONTYPE}
Host: ${NAGIOS_HOSTDISPLAYNAME}
State: ${NAGIOS_HOSTSTATE}
Address: ${NAGIOS_HOSTADDRESS}
Info: ${NAGIOS_SERVICEOUTPUT}
Date/Time: ${NAGIOS_LONGDATETIME}
END
)

else
    MSG=$(cat <<END
*****Nagios*****
Notification Type: ${NAGIOS_NOTIFICATIONTYPE}
Host: ${NAGIOS_HOSTDISPLAYNAME}
State: ${NAGIOS_HOSTSTATE}
Address: ${NAGIOS_HOSTADDRESS}
Info: ${NAGIOS_HOSTOUTPUT}
Date/Time: ${NAGIOS_LONGDATETIME}
END
)

fi

aws sns publish --topic-arn ${TOPIC_ARN} --message "${MSG}" > /dev/null
