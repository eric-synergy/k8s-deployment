resource "vsphere_virtual_machine" "master" {
  name                       = var.vm_name
  resource_pool_id           = data.vsphere_resource_pool.resource_pool.id
  datastore_id               = data.vsphere_datastore.datastore.id
  num_cpus                   = var.vm_cpu
  memory                     = var.vm_ram
  guest_id                   = data.vsphere_virtual_machine.template.guest_id
  scsi_type                  = data.vsphere_virtual_machine.template.scsi_type
  wait_for_guest_net_timeout = -1

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }
  disk {
    label            = "${var.computer_name}_0.vmdk"
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
      ipv4_gateway    = var.ipv4_gateway
      timeout         = 120
    }
  }
  connection {
    host     = var.ipv4_addresses[0]
    type     = "ssh"
    user     = var.vm_username
    password = var.vm_password
  }
  provisioner "file" {
    source      = "${path.module}/scripts/k8s_install.sh"
    destination = "/tmp/k8s_install.sh"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/k8s_master.sh"
    destination = "/tmp/k8s_master.sh"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/hostpath.sh"
    destination = "/tmp/hostpath.sh"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/k10_install.sh"
    destination = "/tmp/k10_install.sh"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/shopping.sh"
    destination = "/tmp/shopping.sh"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/flannel.tpl"
    destination = "/tmp/kube-flannel.yml"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/metallb.yaml"
    destination = "/tmp/metallb.yaml"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/k10_nlb.yaml"
    destination = "/tmp/k10_nlb.yaml"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/shopping_nlb.yaml"
    destination = "/tmp/shopping_nlb.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/k8s_install.sh",
      "chmod +x /tmp/k8s_master.sh",
      "chmod +x /tmp/hostpath.sh",
      "chmod +x /tmp/k10_install.sh",
      "chmod +x /tmp/shopping.sh",      
      "echo ${var.vm_password} | sudo /tmp/k8s_install.sh",
      "echo ${var.vm_password} | sudo /tmp/k8s_master.sh",
      "echo ${var.vm_password} | sudo /tmp/hostpath.sh",
      "echo ${var.vm_password} | sudo /tmp/k10_install.sh",
      "echo ${var.vm_password} | sudo /tmp/shopping.sh",
      "echo ${var.vm_password} | sudo kubectl apply -f /tmp/metallb.yaml",
      "echo ${var.vm_password} | sudo kubectl apply -f /tmp/k10_nlb.yaml",
      "echo ${var.vm_password} | sudo kubectl apply -f /tmp/shopping_nlb.yaml",      
      "echo ${var.vm_password} | sudo kubeadm token create --print-join-command > /tmp/token.txt"
    ]
  }



  provisioner "local-exec" {
    command = "echo 'y' | pscp -pw ${var.vm_password}  ${var.vm_username}@${var.ipv4_addresses[0]}:/tmp/token.txt ${path.module}/scripts/token.sh"
  }
}


