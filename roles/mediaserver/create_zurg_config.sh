#!/usr/bin/env bash
TPL_PATH=/etc/zurg/config.yaml.tpl
TOKEN=$( cat /run/secrets/zurg_token )

[[ -e "/etc/zurg" ]] || mkdir -p /etc/zurg
sed "s/<TOKEN>/$TOKEN/" $TPL_PATH > /etc/zurg/config.yaml
