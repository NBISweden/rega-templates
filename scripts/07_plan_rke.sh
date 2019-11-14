#!/usr/bin/env sh

terraform init -input=false -backend-config=backend.cfg -plugin-dir=terraform_plugins
terraform plan -target=module.rke
