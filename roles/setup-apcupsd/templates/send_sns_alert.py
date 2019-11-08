#!/usr/bin/env python
# coding: utf-8
import argparse
import os
import boto3

sns = boto3.client('sns')

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--sns-arn', type=str, help="SNS ARN to send messages by")

    args = parser.parse_args()

    response = sns.publish(TargetArn=args.sns_arn,
                           Message=bytes(os.environ['MSG'], "utf-8").decode("unicode_escape"),
                           Subject='SNS Alert',
                           )
