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

printf "$MSG" | apprise --config {{ scripts_dir }}/apprise.conf --tag default
