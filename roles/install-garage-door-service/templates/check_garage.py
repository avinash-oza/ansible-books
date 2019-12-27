#!/usr/bin/env python
import requests
import argparse
import boto3
import datetime

sns = boto3.client('sns')


def check_garage(api_endpoint):
    resp = requests.get(api_endpoint)
    exit_code = 0
    try:
        resp.raise_for_status()
    except requests.HTTPError as e:
        msg = "Exception when contacting API: {}".format(e)
        print(msg)
        return msg, 2

    resp_dict = resp.json()
    status_text = ""
    status_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%m:%S %p')
    for g in resp_dict['status']:
        garage_status_text = g['status']
        if g['error'] or g['is_open']:
            # send alert and bold open garage
            garage_status_text = "*{}*".format(g['status'])
            exit_code = 2

        status_text += "{}: {} {}\n".format(g['garage_name'], garage_status_text, status_time)

    return status_text, exit_code


def submit_check(api_endpoint, sns_arn):
    status_text, exit_code = check_garage(api_endpoint)
    # print(status_text)
    if int(exit_code):
        response = sns.publish(TargetArn=sns_arn,
                               Message=status_text,
                               Subject='SNS Alert',
                               )
        print(response)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--api-endpoint', type=str, default='http://localhost:25678/garage/status',
                        help="Garage status API endpoint")
    parser.add_argument('--sns-arn', type=str, help="SNS ARN to send meessages by")

    args = parser.parse_args()

    submit_check(args.api_endpoint, args.sns_arn)
