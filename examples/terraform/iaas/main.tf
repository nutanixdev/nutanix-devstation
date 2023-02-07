#################################################
# NUTANIX PROVIDER DEFINITION
#################################################

terraform {
  required_providers {
    nutanix = {
      source  = "nutanix/nutanix"
      version = "1.7.1"
    }
  }
}

provider "nutanix" {
  username = var.NUTANIX_USERNAME
  password = var.NUTANIX_PASSWORD
  endpoint = var.NUTANIX_ENDPOINT
  port     = var.NUTANIX_PORT
  insecure = var.NUTANIX_INSECURE
}

#################################################
# GET CLUSTERS DATA
#################################################

data "nutanix_clusters" "clusters" {}

locals {
  cluster1 = [
    for cluster in data.nutanix_clusters.clusters.entities :
    cluster.metadata.uuid if cluster.service_list[0] != "PRISM_CENTRAL"
  ][0]
}

#################################################
# CREATE EXTERNAL SUBNET
#################################################

resource "nutanix_subnet" "external-subnet" {
  # What cluster will this VLAN live on?
  cluster_uuid = local.cluster1

  # General Information
  name        = var.EXTERNAL_SUBNET
  vlan_id     = 101
  subnet_type = "VLAN"

  # Managed L3 Networks
  # This bit is only needed if you intend to turn on IPAM
  prefix_length = 27

  default_gateway_ip = "10.45.3.193"
  subnet_ip          = "10.45.3.192"
  is_external = true
  enable_nat = true

  ip_config_pool_list_ranges = ["10.45.3.197 10.45.3.207"]

}

#################################################
# CREATE VPC
#################################################

# Create two VPCs with reference to external subnet
resource "nutanix_vpc" "vpc_tf" {
  count = length(var.VPC)
  name = var.VPC[count.index]
  external_subnet_reference_name = [
    resource.nutanix_subnet.external-subnet.name
  ]
}


locals {
  vpc_uuid = [resource.nutanix_vpc.vpc_tf[0].metadata.uuid,resource.nutanix_vpc.vpc_tf[1].metadata.uuid]
}


#################################################
# CREATE OVERLAY SUBNET
#################################################


# Create two Overlay Subnet-A attached to each VPC
resource "nutanix_subnet" "subnetOverlay" {
  count = length(var.SUBNET_A)
  name                 = var.SUBNET_A[count.index]
  subnet_type                = "OVERLAY"
  subnet_ip                  = "192.168.1.0"
  prefix_length              = 24
  default_gateway_ip         = "192.168.1.1"
  ip_config_pool_list_ranges = ["192.168.1.10 192.168.1.20"]
  dhcp_domain_name_server_list = ["8.8.8.8"]
  vpc_reference_uuid = "${local.vpc_uuid[count.index]}"
  depends_on = [
    nutanix_vpc.vpc_tf
  ]
}

# Create two Overlay Subnet-B attached to each VPC
resource "nutanix_subnet" "subnetOverlayB" {
  count = length(var.SUBNET_B)
  name                 = var.SUBNET_B[count.index]
  subnet_type                = "OVERLAY"
  subnet_ip                  = "192.168.2.0"
  prefix_length              = 24
  default_gateway_ip         = "192.168.2.1"
  ip_config_pool_list_ranges = ["192.168.2.10 192.168.2.20"]
  dhcp_domain_name_server_list = ["8.8.8.8"]
  vpc_reference_uuid = "${local.vpc_uuid[count.index]}"
  depends_on = [
    nutanix_vpc.vpc_tf
  ]
}



#################################################
# CREATE VM
#################################################

# resource "nutanix_image" "ubuntu" {
#   name = "ubuntu"
#   source_uri  = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
# }

data "nutanix_image" "centos" {
    image_name = var.IMAGE_NAME
}


locals {
  subnet_uuid_a = [resource.nutanix_subnet.subnetOverlay[0].metadata.uuid,resource.nutanix_subnet.subnetOverlay[1].metadata.uuid]
  subnet_uuid_b = [resource.nutanix_subnet.subnetOverlayB[0].metadata.uuid,resource.nutanix_subnet.subnetOverlayB[1].metadata.uuid]
}


# Create two Application VM's attached to each Subnet-A
resource "nutanix_virtual_machine" "vm_tf" {
  count = length(var.VM_APP)
  name                 = var.VM_APP[count.index]
  num_vcpus_per_socket = 1
  num_sockets          = 1
  memory_size_mib      = 2048
  cluster_uuid         = local.cluster1
  
  nic_list {
     subnet_uuid = "${local.subnet_uuid_a[count.index]}"
  }

  disk_list {
    data_source_reference = {
      kind = "image"
      uuid = data.nutanix_image.centos.id
    }
    device_properties {
      disk_address = {
        device_index = 0
        adapter_type = "SCSI"
      }

      device_type = "DISK"
    }
  }
  disk_list {
    disk_size_mib   = 100000
    #disk_size_bytes = 104857600000
  }

  disk_list {
    disk_size_bytes = 0
    data_source_reference = {}
    device_properties {
      device_type = "CDROM"
      disk_address = {
        device_index = "1"
        adapter_type = "SATA"
      }
    }
  }
  depends_on = [nutanix_subnet.subnetOverlay]
}


# Create two Database VM's attached to each Subnet-B
resource "nutanix_virtual_machine" "vm_tf_db" {
  count = length(var.VM_DB)
  name                 = var.VM_DB[count.index]
  num_vcpus_per_socket = 1
  num_sockets          = 1
  memory_size_mib      = 2048
  cluster_uuid         = local.cluster1
  
  nic_list {
    subnet_uuid = "${local.subnet_uuid_b[count.index]}"
  }

  disk_list {
    data_source_reference = {
      kind = "image"
      uuid = data.nutanix_image.centos.id
    }
    device_properties {
      disk_address = {
        device_index = 0
        adapter_type = "SCSI"
      }

      device_type = "DISK"
    }
  }
  disk_list {
    disk_size_mib   = 100000
    #disk_size_bytes = 104857600000
  }

  disk_list {
    disk_size_bytes = 0
    data_source_reference = {}
    device_properties {
      device_type = "CDROM"
      disk_address = {
        device_index = "1"
        adapter_type = "SATA"
      }
    }
  }
  depends_on = [nutanix_subnet.subnetOverlayB]
}


#################################################
# CREATE FLOATING IP
#################################################

locals {
  vpc_reference_uuid = [resource.nutanix_vpc.vpc_tf[0].metadata.uuid,resource.nutanix_vpc.vpc_tf[1].metadata.uuid]
  vm_nic_reference_uuid = [resource.nutanix_virtual_machine.vm_tf[0].nic_list[0].uuid, resource.nutanix_virtual_machine.vm_tf[1].nic_list[0].uuid]
  private_ip = ["192.168.1.11", "192.168.1.12"]
}

resource "nutanix_floating_ip" "fip" {
  count = length(local.vpc_reference_uuid)
  external_subnet_reference_name = resource.nutanix_subnet.external-subnet.name
  vpc_reference_uuid = "${local.vpc_reference_uuid[count.index]}"
  private_ip = "${local.private_ip[count.index]}"
  #vm_nic_reference_uuid = "${local.vm_nic_reference_uuid[count.index]}"
  
  depends_on = [
    nutanix_virtual_machine.vm_tf
  ]
}

