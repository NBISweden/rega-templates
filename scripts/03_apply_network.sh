#!/usr/bin/env bash

terraform apply -auto-approve -parallelism=10 -target=module.network
