# Terraform and ansible templates for rke-openstack (rega)

Also see the (rke-openstack)[https://github.com/NBISweden/rke-openstack] repo
for information.


## Edit these files

### Config terraform in `terraform.tfvars`

```yml
## Cluster configuration ##
# Unique name for the resources
cluster_prefix="my-test"
# User for ssh connections. It varies among distributions. (CentOS might work with cloud-user or centos)
ssh_user="<ssh-user>"
# Network settings
external_network_id=""
floating_ip_pool=""
# Image name (RKE runs on almost any Linux OS)
image_name="<image-name>"
# Node counts and flavours (Note that these flavours are only indicative)
master_flavor_name="ssc.medium"
master_count=1
service_flavor_name="ssc.medium"
service_count=2
edge_flavor_name="ssc.medium"
edge_count=1
# Please check that the Kubernetes version is RKE 0.2.x compliant)
kubernetes_version="v1.14.6-rancher1-1"

# Security groups
allowed_ingress_tcp={
  # These are the ports you need to work with kubernetes and rancher from your
  # machine.
  #"<YOUR CIDR>" = [22, 6443, 80, 443, 10250]
}
allowed_ingress_udp={}
secgroups = []
```

### Terraform state backend

If you want the state to be stored into a S3 remote backend you can add the following configuration to the `backend.cfg` file:

```
access_key = "xyz"
secret_key = "xyz"
bucket = "bucketname"
region = "us-east-1"
endpoint = "https://s3.endpoint"
key = "terraform.tfstate"
skip_requesting_account_id = true
skip_credentials_validation = true
skip_get_ec2_platforms = true
skip_metadata_api_check = true
skip_region_validation = true
```

And for Swift:

```
container          = "cluster-state"
archive_container  = "cluster-state-archive"
```

## Stand-alone deployment

Create a private/public keypair with `ssh-keygen`.

```bash
ssh-keygen -f ssh_key
```

### Source the extra env vars

```console
source OPENSTACK_CREDENTIALS.sh
source <(./scripts/01_source_extra_vars.sh)
```

### Init terraform

```bash
./scripts/02_init_download_terraform_plugins.sh
terraform init -backend=backend.cfg
```

### Deploy

```bash
./scripts/03_apply_network.sh
./scripts/04_apply_secgroups.sh
./scripts/05_apply_infra.sh
```

Edit the `playbooks/roles/all` file to contain approximately:

```yaml
edge_host: {PREFIX}-edge-000
edge_ip: '{{ hostvars.get(edge_host)["ansible_host"] }}'
private_key: ssh_key
ssh_user: ubuntu
```

Run ansible

```bash
./scripts/06_provision_docker.sh
```

Deploy rke cluster

```bash
./scripts/07_apply_rke.sh
```

To access the kubernetes environment

```bash
export KUBECONFIG="${PWD}/kube_config_cluster.yml"
kubectl get nodes
```
