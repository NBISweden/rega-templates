#!/usr/bin/env bash

terraform destroy -auto-approve -parallelism=10 -target=module.master -target=module.service -target=module.edge -target=module.ansible -target=module.keypair
