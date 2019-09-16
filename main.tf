# Upload SSH key to OpenStack
module "keypair" {
  source         = "./modules/keypair"
  public_ssh_key = var.ssh_key_pub
  key_prefix     = var.cluster_prefix
}

# Create security group
module "secgroup" {
  source              = "./modules/secgroup"
  name_prefix         = var.cluster_prefix
  allowed_ingress_tcp = var.allowed_ingress_tcp
  allowed_ingress_udp = var.allowed_ingress_udp
}

# Create network
module "network" {
  source              = "./modules/network"
  name_prefix         = var.cluster_prefix
  external_network_id = var.external_network_id
}

# Create master node
module "master" {
  source             = "./modules/node"
  node_count         = var.master_count
  name_prefix        = "${var.cluster_prefix}-master"
  flavor_name        = var.master_flavor_name
  image_name         = var.image_name
  cloud_init_data    = var.cloud_init_data
  network_name       = module.network.network_name
  secgroups_name     = [module.secgroup.secgroup_name, var.secgroups]
  floating_ip_pool   = var.floating_ip_pool
  ssh_user           = var.ssh_user
  ssh_key            = var.ssh_key
  os_ssh_keypair     = module.keypair.keypair_name
  assign_floating_ip = var.master_assign_floating_ip
  role    = "[controlplane, etcd]"
  node_type = "master"
}

# Create service nodes
module "service" {
  source             = "./modules/node"
  node_count         = var.service_count
  name_prefix        = "${var.cluster_prefix}-service"
  flavor_name        = var.service_flavor_name
  image_name         = var.image_name
  cloud_init_data    = var.cloud_init_data
  network_name       = module.network.network_name
  secgroups_name     = [module.secgroup.secgroup_name, var.secgroups]
  floating_ip_pool   = var.floating_ip_pool
  ssh_user           = var.ssh_user
  ssh_key            = var.ssh_key
  os_ssh_keypair     = module.keypair.keypair_name
  assign_floating_ip = var.service_assign_floating_ip
  role    = "[worker]"
  node_type = "service"
}

# Create edge nodes
module "edge" {
  source             = "./modules/node"
  node_count         = var.edge_count
  name_prefix        = "${var.cluster_prefix}-edge"
  flavor_name        = var.edge_flavor_name
  image_name         = var.image_name
  cloud_init_data    = var.cloud_init_data
  network_name       = module.network.network_name
  secgroups_name     = [module.secgroup.secgroup_name, var.secgroups]
  floating_ip_pool   = var.floating_ip_pool
  ssh_user           = var.ssh_user
  ssh_key            = var.ssh_key
  os_ssh_keypair     = module.keypair.keypair_name
  assign_floating_ip = var.edge_assign_floating_ip
  role    = "[worker]"
  node_type = "edge"
}

# Provision Kubernetes
module "rke" {
  source                    = "./modules/rke"
  master_nodes              = module.master.nodes
  edge_nodes                = module.edge.nodes
  service_nodes             = module.service.nodes
  ssh_bastion_host          = element(flatten([module.edge.public_ip_list, module.master.public_ip_list]), 0) 
  ssh_user                  = var.ssh_user
  ssh_key                   = var.ssh_key
  kubeapi_sans_list         = module.edge.public_ip_list
  ignore_docker_version     = var.ignore_docker_version
  kubernetes_version        = var.kubernetes_version
  write_kube_config_cluster = var.write_kube_config_cluster
  write_cluster_yaml        = var.write_cluster_yaml
  os_username               = var.os_username
  os_password               = var.os_password
  os_auth_url               = var.os_auth_url
  os_project_id             = var.os_project_id
  os_project_name           = var.os_project_name
  os_user_domain_name       = var.os_user_domain_name
}

# Generate Ansible files
module "ansible" {
  source             = "./modules/ansible"
  cluster_prefix     = var.cluster_prefix
  ssh_user           = var.ssh_user
  master_nodes       = module.master.nodes
  edge_nodes         = module.edge.nodes
  service_nodes      = module.service.nodes
  master_count       = var.master_count
  edge_count         = var.edge_count
  service_count      = var.service_count
  inventory_template = var.inventory_template
}
