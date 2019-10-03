#!/usr/bin/env bash

terraform init -input=false -backend-config=backend.cfg -plugin-dir=terraform_plugins
terraform plan -parallelism=1 -target=module.secgroup
