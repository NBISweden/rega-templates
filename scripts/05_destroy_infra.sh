#!/usr/bin/env sh

terraform destroy -auto-approve -parallelism=10 -target=module.master -target=module.service -target=module.edge -target=module.ansible -target=module.keypair
