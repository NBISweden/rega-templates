#!/usr/bin/env bash

terraform plan -parallelism=10 -target=module.network 
