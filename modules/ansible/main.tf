variable ssh_user {}
variable cluster_prefix {}
variable public_host {}

variable master_nodes {}
variable edge_nodes {}
variable service_nodes {}

variable master_count {}
variable service_count {}
variable edge_count {}

variable inventory_template {}

variable inventory_output_file {
  default = "inventory"
}

locals {

  master_hostnames  = slice(var.master_nodes[*].hostname,  0, min(var.master_count, length(var.master_nodes[*].hostname)))
  master_private_ip = slice(var.master_nodes[*].internal_address, 0, min(var.master_count, length(var.master_nodes[*].internal_address)))

  edge_hostnames  = slice(var.edge_nodes[*].hostname,  0, min(var.edge_count, length(var.edge_nodes[*].hostname)))
  edge_private_ip = slice(var.edge_nodes[*].internal_address, 0, min(var.edge_count, length(var.edge_nodes[*].internal_address)))

  service_hostnames  = slice(var.service_nodes[*].hostname,  0, min(var.service_count, length(var.service_nodes[*].hostname)))
  service_private_ip = slice(var.service_nodes[*].internal_address, 0, min(var.service_count, length(var.service_nodes[*].internal_address)))

  masters  = join("\n",formatlist("%s ansible_host=%s ansible_user=%s private_ip=%s", local.master_hostnames,  slice(var.master_nodes[*].address,  0, var.master_count),  var.ssh_user, local.master_private_ip  ))
  edges    = join("\n",formatlist("%s ansible_host=%s ansible_user=%s private_ip=%s", local.edge_hostnames,    slice(var.edge_nodes[*].address,    0, var.edge_count),    var.ssh_user, local.edge_private_ip    ))
  services = join("\n",formatlist("%s ansible_host=%s ansible_user=%s private_ip=%s", local.service_hostnames, slice(var.service_nodes[*].address, 0, var.service_count), var.ssh_user, local.service_private_ip ))
}

# Generate inventory from template file
data "template_file" "inventory" {
  template = "${file("${path.root}/${ var.inventory_template }")}"

  vars = {
    masters                = local.masters
    edges                  = local.edges
    services               = local.services
  }
}

# Generate group_vars/all from template file
data "template_file" "group_vars" {
  template = file("${path.root}/${ var.group_vars_template_file }")

  vars = {
    ssh_user               = var.ssh_user
    public_host            = var.public_host
    edge_count             = var.edge_count
  }
}

# Write the template to a file
resource "null_resource" "local" {
  # Trigger rewrite of inventory, uuid() generates a random string everytime it is called
  triggers = {
    uuid = uuid()
    template = data.template_file.inventory.rendered
}
  provisioner "local-exec" {
    command = "echo \"${data.template_file.inventory.rendered}\" > \"${path.root}/${var.inventory_output_file}\""
  }
}
