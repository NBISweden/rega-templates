#!/usr/bin/env sh

terraform init -input=false -backend-config=backend.cfg -plugin-dir=terraform_plugins
terraform apply -auto-approve -parallelism=10 -target=module.rke
