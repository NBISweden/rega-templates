output "public_ip_list" {
  description = "List of floating IP addresses"
  value       = flatten([openstack_compute_floatingip_v2.floating_ip.*.address])
}

output "nodes" {
  value = flatten([data.null_data_source.nodes.*.inputs])
}
