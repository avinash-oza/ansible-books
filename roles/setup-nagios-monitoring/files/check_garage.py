#!/usr/bin/env python
import argparse
import datetime
import sys

import requests


def check_garage(api_endpoint):
    resp = requests.get(api_endpoint, timeout=10)
    exit_code = 0
    try:
        resp.raise_for_status()
    except requests.HTTPError as e:
        msg = "Exception when contacting API: {}".format(e)
        print(msg)
        return msg, 2

    resp_dict = resp.json()
    status_text = ""
    status_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S %p')
    for g in resp_dict['status']:
        garage_status_text = g['status']
        if g['error'] or g['is_open']:
            garage_status_text = g['status']
            exit_code = 2

        status_text += "{}: {} {}\n".format(g['garage_name'], garage_status_text, status_time)

    return status_text, exit_code


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--api-endpoint', type=str, default='http://localhost:25678/garage/status',
                        help="Garage status API endpoint")

    args = parser.parse_args()

    text, exit_code = check_garage(args.api_endpoint)
    print(text)
    sys.exit(exit_code)
