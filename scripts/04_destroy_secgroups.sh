#!/usr/bin/env sh

terraform destroy -auto-approve -parallelism=1  -target=module.secgroup
