#!/usr/bin/env sh

terraform destroy -auto-approve -parallelism=10 -target=module.network
