output "vsphere_network" {
  value = data.vsphere_network.network.id
}
output "vsphere_datastore" {
  value = data.vsphere_datastore.datastore.id
}
output "vsphere_resource_pool" {
  value = data.vsphere_resource_pool.resource_pool.id
}

output "ip" {
  value = vsphere_virtual_machine.master.guest_ip_addresses
}
# output "ipv4" {
#   value = {
#       for vm in vsphere_virtual_machine.vm:
#       vm.name => vm.*.network_interface.0.default_ip_address
#   }
# }



# output "ipv6" {
#   value = {
#       for vm in vsphere_virtual_machine.vm:
#       vm.name => vm.*.network_interface.0.default_ip_address
#   }
# }