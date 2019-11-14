#!/usr/bin/env sh

set -e

export ARCH=amd64
# OS=darwin, OS=linux
export OS=$(uname | tr '[:upper:]' '[:lower:]')
# Terraform plugin versions
export PLUGIN_OPENSTACK=1.21.1
export PLUGIN_RKE=0.14.1
export PLUGIN_KUBERNETES=1.8.1
export PLUGIN_NULL=2.1.2
export PLUGIN_LOCAL=1.3.0
export PLUGIN_TEMPLATE=2.1.2
export PLUGIN_RANDOM=2.2.0

# Install Terraform plugins
mkdir -p ./terraform_plugins
curl "https://releases.hashicorp.com/terraform-provider-openstack/${PLUGIN_OPENSTACK}/terraform-provider-openstack_${PLUGIN_OPENSTACK}_${OS}_${ARCH}.zip" > \
    "terraform-provider-openstack_${PLUGIN_OPENSTACK}_${OS}_${ARCH}.zip" && \
    unzip "terraform-provider-openstack_${PLUGIN_OPENSTACK}_${OS}_${ARCH}.zip" -d ./terraform_plugins/ && \
    rm "terraform-provider-openstack_${PLUGIN_OPENSTACK}_${OS}_${ARCH}.zip"

curl "https://releases.hashicorp.com/terraform-provider-kubernetes/${PLUGIN_KUBERNETES}/terraform-provider-kubernetes_${PLUGIN_KUBERNETES}_${OS}_${ARCH}.zip" > \
    "terraform-provider-kubernetes_${PLUGIN_KUBERNETES}_${OS}_${ARCH}.zip" && \
    unzip "terraform-provider-kubernetes_${PLUGIN_KUBERNETES}_${OS}_${ARCH}.zip" -d ./terraform_plugins/ && \
    rm "terraform-provider-kubernetes_${PLUGIN_KUBERNETES}_${OS}_${ARCH}.zip"

curl "https://releases.hashicorp.com/terraform-provider-null/${PLUGIN_NULL}/terraform-provider-null_${PLUGIN_NULL}_${OS}_${ARCH}.zip" > \
    "terraform-provider-null_${PLUGIN_NULL}_${OS}_${ARCH}.zip" && \
    unzip "terraform-provider-null_${PLUGIN_NULL}_${OS}_${ARCH}.zip" -d ./terraform_plugins/ && \
    rm "terraform-provider-null_${PLUGIN_NULL}_${OS}_${ARCH}.zip"

curl "https://releases.hashicorp.com/terraform-provider-local/${PLUGIN_LOCAL}/terraform-provider-local_${PLUGIN_LOCAL}_${OS}_${ARCH}.zip" > \
    "terraform-provider-local_${PLUGIN_LOCAL}_${OS}_${ARCH}.zip" && \
    unzip "terraform-provider-local_${PLUGIN_LOCAL}_${OS}_${ARCH}.zip" -d ./terraform_plugins/ && \
    rm "terraform-provider-local_${PLUGIN_LOCAL}_${OS}_${ARCH}.zip"

curl -sL "https://github.com/yamamoto-febc/terraform-provider-rke/releases/download/${PLUGIN_RKE}/terraform-provider-rke_${PLUGIN_RKE}_${OS}-${ARCH}.zip" > \
    "terraform-provider-rke_${PLUGIN_RKE}_${OS}_${ARCH}.zip" && \
    unzip "terraform-provider-rke_${PLUGIN_RKE}_${OS}_${ARCH}.zip" -d ./terraform_plugins/ && \
    rm "terraform-provider-rke_${PLUGIN_RKE}_${OS}_${ARCH}.zip"

curl "https://releases.hashicorp.com/terraform-provider-template/${PLUGIN_TEMPLATE}/terraform-provider-template_${PLUGIN_TEMPLATE}_${OS}_${ARCH}.zip" > \
    "terraform-provider-template_${PLUGIN_TEMPLATE}_${OS}_${ARCH}.zip" && \
    unzip "terraform-provider-template_${PLUGIN_TEMPLATE}_${OS}_${ARCH}.zip" -d ./terraform_plugins/ && \
    rm "terraform-provider-template_${PLUGIN_TEMPLATE}_${OS}_${ARCH}.zip"

curl "https://releases.hashicorp.com/terraform-provider-random/${PLUGIN_RANDOM}/terraform-provider-random_${PLUGIN_RANDOM}_${OS}_${ARCH}.zip" > \
    "terraform-provider-random_${PLUGIN_RANDOM}_${OS}_${ARCH}.zip" && \
    unzip "terraform-provider-random_${PLUGIN_RANDOM}_${OS}_${ARCH}.zip" -d ./terraform_plugins/ && \
    rm "terraform-provider-random_${PLUGIN_RANDOM}_${OS}_${ARCH}.zip"
