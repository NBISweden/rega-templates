#!/usr/bin/env bash

terraform destroy -auto-approve -parallelism=1  -target=module.secgroup
