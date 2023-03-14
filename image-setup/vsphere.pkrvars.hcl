##################################################################################
# VARIABLES
##################################################################################
# Credentials

vcenter_username                = "veeam@vsphere.local"
vcenter_password                = "P@ssw0rd1"

# vSphere Objects

vcenter_insecure_connection     = true
vcenter_server                  = "vc.veeamlab.local"
vcenter_datacenter              = "VeeamDatacenter"
vcenter_host                    = "esxi02.veeamlab.local"
vcenter_datastore               = "ESXI02_Datastore"
vcenter_network                 = "guest110"
vcenter_folder                  = "Templates"
vcenter_cluster                 = "VeeamLabCluster"
vcenter_resource_pool           = "templates"
# ISO Objects
// iso_path                        = "[NFS] ISO/ubuntu-20.04.2-live-server-amd64.iso"

os_iso_path = "[NFS] ISO/ubuntu-20.04.2-live-server-amd64.iso"