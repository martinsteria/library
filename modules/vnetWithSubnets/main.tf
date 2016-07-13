#VnetwithSubnets

variable "location" {}
variable "resourceGroupName" {}
variable "name" {}
variable "addressSpace" {}
variable "subnetCount" {
  default = "1"
}
variable "subnetAdditionalBits" {}

module "vnet" {
  source = "../../resources/virtualNetwork"
  resourceGroupName = "${var.resourceGroupName}"
  location = "${var.location}"
  name = "${var.name}"
  addressSpace = "${var.addressSpace}"
}

module "subnet" {
  source = "../../resources/subnet"
  resourceGroupName = "${var.resourceGroupName}"
  count = "${var.subnetCount}"
  virtualNetworkName = "${var.name}"
  virtualNetworkAddressSpace = "${var.addressSpace}"
  additionalBits = "${var.subnetAdditionalBits}"
}

output "subnetIDSplat" {
  value = "${module.subnet.idSplat}"
}
