variable "NUTANIX_USERNAME" {}
variable "NUTANIX_PASSWORD" {}
variable "NUTANIX_ENDPOINT" {}
variable "NUTANIX_INSECURE" {}
variable "NUTANIX_PORT" {}
variable "NUTANIX_WAIT_TIMEOUT" {}
variable "IMAGE_NAME" {}

//External VLAN
variable "EXTERNAL_SUBNET" {
  type = string
}

variable "VPC" {
  type = list(string)
}

variable "SUBNET_A" {
  type = list(string)
}

variable "SUBNET_B" {
  type = list(string)
}

variable "VM_APP" {
  type = list(string)
}

variable "VM_DB" {
  type = list(string)
}
