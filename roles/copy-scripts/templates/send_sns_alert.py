#!/usr/bin/env python
# coding: utf-8
import argparse
import os
import sys

import boto3

sns = boto3.client('sns')

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--sns-arn', type=str, help="SNS ARN to send messages by")
    parser.add_argument('--stdin', action='store_true', help="read msg from stdin")

    args = parser.parse_args()
    if args.stdin:
        input_src = sys.stdin.read().rstrip('\n')
    else:
        input_src = os.environ['MSG']

    response = sns.publish(TargetArn=args.sns_arn,
                           Message=bytes(input_src, "utf-8").decode("unicode_escape"),
                           Subject='SNS Alert',
                           )
