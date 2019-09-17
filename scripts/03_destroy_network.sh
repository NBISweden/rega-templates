#!/usr/bin/env bash

terraform destroy -auto-approve -parallelism=10 -target=module.network
