#!/usr/bin/env python
import requests
import argparse


def check_garage(api_endpoint):
    resp = requests.get(api_endpoint)
    exit_code = 0
    try:
        resp.raise_for_status()
    except requests.HTTPError as e:
        print("Exception when contacting API: {}".format(e))
        exit_code = 2

    resp_dict = resp.json()
    status_text = "".join(["{} is {}.".format(k['garage_name'], k['status']) for k in resp_dict['status']])

    if any(k['error'] for k in resp_dict['status']) or any(k['status'] == 'OPEN' for k in resp_dict['status']):
        # exit with error code if any garage is open or error
        exit_code = 2
    return status_text, exit_code

def submit_check(api_endpoint):
    status_text, exit_code = check_garage(api_endpoint)
    if int(exit_code):
        # send SNS notification here
        print(status_text, exit_code)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--api-endpoint', type=str, default='http://localhost:25678/garage/status',
                        help="Garage status API endpoint")
    args = parser.parse_args()

    submit_check(args.api_endpoint)
