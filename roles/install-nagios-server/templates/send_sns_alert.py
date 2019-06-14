#!/usr/bin/env python
# coding: utf-8
import argparse
import os
import boto3

sns = boto3.client('sns')

MESSAGE_TEXT = """
***** Nagios *****
Notification Type: {alert_type}

State: {host_state}
Address: {host_address}
Info: {output_text}
Date/Time: {n_datetime}"""


def insert_new_entry(service_alert, sns_arn):
    env = os.environ
    # Parameters for alerts
    notification_type = env.get('NAGIOS_NOTIFICATIONTYPE')
    host_name = env.get('NAGIOS_HOSTNAME')
    host_state = env.get('NAGIOS_HOSTSTATE')
    host_address = env.get('NAGIOS_HOSTADDRESS')
    service_output = env.get('NAGIOS_SERVICEOUTPUT')
    host_output = env.get('NAGIOS_HOSTOUTPUT')
    nagios_date_time = env.get('NAGIOS_LONGDATETIME')
    service_name = env.get('NAGIOS_SERVICEDISPLAYNAME')  # The display name of the service

    data_dict = {'host_name': host_name,
                 'host_state': host_state,
                 'host_address': host_address,
                 'n_datetime': nagios_date_time,
                 'service_name': service_name,
                 'notification_type': notification_type}

    if service_alert:
        data_dict['alert_type'] = 'SERVICE'
        data_dict['output_text'] = service_output
    else:
        # Host alert
        print("Host alert")
        data_dict['alert_type'] = 'HOST'
        data_dict['output_text'] = host_output

    response = sns.publish(TargetArn=sns_arn,
                           Message=MESSAGE_TEXT.format(**data_dict),
                           Subject='SNS Alert',
                           )

    print("Sent {} alert".format(data_dict['alert_type']))


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--service', action='store_true', help="This is a service alert")
    parser.add_argument('--sns-arn', type=str, help="SNS ARN to send meessages by")
    args = parser.parse_args()

    insert_new_entry(args.service, args.sns_arn)
