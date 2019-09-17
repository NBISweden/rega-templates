#!/usr/bin/env bash

terraform apply -auto-approve -parallelism=1  -target=module.secgroup
