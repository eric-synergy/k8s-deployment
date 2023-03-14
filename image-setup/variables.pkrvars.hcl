http_directory = "http"
vm_name                     = "Ubuntu-2004-K8S-Thin"
vm_guest_os_type            = "ubuntu64Guest"
vm_version                  = 14
vm_firmware                 = "bios"
vm_cdrom_type               = "sata"
vm_cpu_sockets              = 1
vm_cpu_cores                = 4
vm_mem_size                 = 4096
vm_disk_size                = 61440
thin_provision              = true
disk_eagerly_scrub          = false
vm_disk_controller_type     = ["pvscsi"]
vm_network_card             = "vmxnet3"
vm_boot_wait                = "5s"
ssh_username                = "veeamadmin"
ssh_password                = "Veeam123!"


// iso_path                    = "iso"
// iso_file                    = "ubuntu-20.04.3-live-server-amd64.iso"
// iso_checksum                = "f8e3086f3cea0fb3fefb29937ab5ed9d19e767079633960ccb50e76153effc98"
// iso_checksum_type           = "sha256"
// iso_url                     = "https://releases.ubuntu.com/20.04.3/ubuntu-20.04.3-live-server-amd64.iso"


shell_scripts               = ["scripts/setup.sh"]
