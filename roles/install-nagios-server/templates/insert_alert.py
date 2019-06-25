#!/usr/bin/env python
# coding: utf-8
import argparse
import os
import boto3
import json

MESSAGE_TEXT = """
***** Nagios *****
Notification Type: {alert_type}

State: {host_state}
Address: {host_address}
Info: {output_text}
Date/Time: {n_datetime}"""


def insert_new_entry(service_alert):
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
        print("Service called")
        data_dict['alert_type'] = 'SERVICE'
        data_dict['output_text'] = service_output
    else:
        # Host alert
        print("Host alert")
        data_dict['alert_type'] = 'HOST'
        data_dict['output_text'] = host_output

    data_dict['message_text'] = MESSAGE_TEXT.format(**data_dict)

    sqs = boto3.resource('sqs')
    q = sqs.get_queue_by_name(QueueName='low-pri-nagios-alerts.fifo')
    q.send_message(MessageBody=json.dumps(data_dict), MessageGroupId='nagios-alerts')


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--service', action='store_true', help="This is a service alert")
    args = parser.parse_args()

    insert_new_entry(args.service)