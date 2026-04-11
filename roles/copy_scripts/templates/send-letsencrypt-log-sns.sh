#!/bin/bash
export AWS_ACCESS_KEY_ID={{ vault_aws_keys['letsencrypt'].key_id }}
export AWS_SECRET_ACCESS_KEY={{ vault_aws_keys['letsencrypt'].access_key }}
export TOPIC_ARN={{ vault_nagios_alert_sns_endpoint }}
export AWS_DEFAULT_REGION={{ vault_aws_default_region }}

content=$(cat /tmp/letsencryptoutput.log)

aws sns publish \
    --topic-arn ${TOPIC_ARN} \
    --message "$content" > /dev/null
