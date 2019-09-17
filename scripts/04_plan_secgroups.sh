#!/usr/bin/env bash

terraform plan -parallelism=1  -target=module.secgroup
