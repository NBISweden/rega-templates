#!/usr/bin/env bash

terraform plan -parallelism=10 -target=module.master -target=module.service -target=module.edge -target=module.inventory -target=module.keypair
