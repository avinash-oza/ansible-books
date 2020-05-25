#!/bin/bash -e

export MSG=""

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

AWS_DEFAULT_REGION={{ vault_aws_default_region }} AWS_ACCESS_KEY_ID={{ vault_aws_access_key_id }} AWS_SECRET_ACCESS_KEY={{ vault_aws_secret_access_key }} /usr/bin/python3 {{ scripts_dir }}/send_sns_alert.py --sns-arn={{ vault_nagios_alert_sns_endpoint }}
#AWS_DEFAULT_REGION={{ vault_aws_default_region }} AWS_ACCESS_KEY_ID={{ vault_aws_access_key_id }} AWS_SECRET_ACCESS_KEY={{ vault_aws_secret_access_key }} {{ python_root }}/python {{ scripts_dir }}/send_sns_alert.py --sns-arn={{ vault_nagios_alert_sns_endpoint }}
