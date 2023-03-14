variable "vsphere_user" {
    type = string
    default = "administrator@vsphere.local"
}

variable "vsphere_password" {
    type = string
    default = "password"
}

variable "vsphere_server" {
    type = string
    default = "vc.demo.local"
}

variable "vsphere_datacenter" {
    type = string
    default = "vc.veeamlab.local"
}

variable "vsphere_datastore" {
    type = string
    default = "datastore"
}

variable "vsphere_compute_cluster" {
    type = string
    default = "cluster"
}

variable "vsphere_network" {
    type = string
    default = "VM network"
}

variable "vsphere_resource_pool" {
    type = string
    default = "resources"
}

variable "vm_name" {
    type = string
    default = "vm"
}

variable "vm_cpu" {
  type        = string
  description = "Number of vCPU for the vSphere virtual machines"
  default     = "2"
}

variable "vm_ram" {
  type        = string
  default     ="4096"
  description = "Amount of RAM for the vSphere virtual machines (example: 2048)"
}

variable "os_template" {
    type = string
    default = "Windows10Template"
}

variable "computer_name" {
  type        = string
  description = "vm password"
}

variable "ipv4_addresses" {
  type        = list(any)
  description = "list IPs"
}

variable "ipv4_netmasks" {
  type        = list(any)
  description = "list of net masks corresponding to the list of IPs"
}

variable "dns_server_list" {
  type        = list(any)
  description = "list of DNS server IPs"
}

variable "ipv4_gateway" {
  type        = string
  description = "Network gateway IP"
}

variable "domain" {
  type        = string
  description = "Domain for DNS and AD"
}

variable "vm_username" {
  type        = string
  description = "vm username"
}

variable "vm_password" {
  type        = string
  description = "vm password"
}
