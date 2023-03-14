resource "vsphere_virtual_machine" "vm" {
  name             = var.vm_name
  resource_pool_id = data.vsphere_resource_pool.resource_pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = var.vm_cpu
  memory           = var.vm_ram
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  scsi_type        = data.vsphere_virtual_machine.template.scsi_type
  wait_for_guest_net_timeout = -1

  network_interface {
    network_id = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }
  disk {
    label             = "${var.computer_name}_0.vmdk"
    thin_provisioned = true
    eagerly_scrub    = false
    size             = data.vsphere_virtual_machine.template.disks.0.size
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = var.computer_name
        domain    = var.domain
      }
      network_interface {
        ipv4_address = var.ipv4_addresses[0]
        ipv4_netmask = var.ipv4_netmasks[0]
        # dns_server_list = var.dns_server_list
        # dns_domain = var.domain        
      }
    dns_server_list = var.dns_server_list
    ipv4_gateway = var.ipv4_gateway
    timeout = 120      
    }
  }
#   connection {
#       host     = "${var.ipv4_addresses[0]}"          
#       type     = "ssh"
#       user     = "${var.vm_username}"
#       password = "${var.vm_password}"
#   }  
#   provisioner "remote-exec" {
#       inline = [
#           "hostnamectl set-hostname ${var.computer_name}"
#       ]  
#   }
}