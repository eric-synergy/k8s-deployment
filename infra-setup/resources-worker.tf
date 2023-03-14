resource "vsphere_virtual_machine" "worker" {
  depends_on = [
    vsphere_virtual_machine.master
  ]
  count = var.worker_vm_count
  name  = var.worker_vm_count == "1" ? "${var.worker_vm_name}" : "${var.worker_vm_name}${count.index + 1}"
  # name             = var.worker_vm_name
  resource_pool_id           = data.vsphere_resource_pool.resource_pool.id
  datastore_id               = data.vsphere_datastore.datastore.id
  num_cpus                   = var.worker_vm_cpu
  memory                     = var.worker_vm_ram
  guest_id                   = data.vsphere_virtual_machine.template.guest_id
  scsi_type                  = data.vsphere_virtual_machine.template.scsi_type
  wait_for_guest_net_timeout = -1

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }
  disk {
    label            = var.worker_vm_count == "1" ? "${var.worker_vm_name}" : "${var.worker_vm_name}${count.index + 1}_0.vmdk"
    thin_provisioned = true
    eagerly_scrub    = false
    size             = data.vsphere_virtual_machine.template.disks.0.size
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = var.worker_vm_count == "1" ? "${var.worker_computer_name}" : "${var.worker_computer_name}${count.index + 1}"
        # host_name = var.worker_computer_name
        domain = var.domain
      }
      network_interface {
        ipv4_address = var.worker_ipv4_addresses[count.index]
        ipv4_netmask = var.worker_ipv4_netmasks[count.index]
        # dns_server_list = var.dns_server_list
        # dns_domain = var.domain        
      }
      dns_server_list = var.worker_dns_server_list
      ipv4_gateway    = var.worker_ipv4_gateway
      timeout         = 120
    }
  }
  connection {
    host     = var.worker_ipv4_addresses[count.index]
    type     = "ssh"
    user     = var.vm_username
    password = var.vm_password
  }

  provisioner "file" {
    source      = "${path.module}/scripts/k8s_install.sh"
    destination = "/tmp/k8s_install.sh"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/token.sh"
    destination = "/tmp/token.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/k8s_install.sh",
      "echo ${var.vm_password} | sudo /tmp/k8s_install.sh",
      "chmod +x /tmp/token.sh",
      "echo ${var.vm_password} | sudo /tmp/token.sh",
    ]
  }
}


