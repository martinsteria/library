#connectedVM
variable "resourceGroupName" {}
variable "location" {}
variable "count" {
  default = "1"
}
variable "name" {}
variable "size" {}
variable "imagePublisher" {}
variable "imageOffer" {}
variable "imageSKU" {}
variable "adminUsername" {}
variable "adminPassword" {}
variable "storageAccountPrimaryBlobEndpoint" {}
variable "subnetID" {}
variable "publicIPAddressID" {
  default = ""
}

module "vm" {
  source = "../../resources/virtualMachines"
  resourceGroupName = "${var.resourceGroupName}"
  location = "${var.location}"
  count = "${var.count}"
  name = "${var.name}"
  size = "${var.size}"
  imagePublisher = "${var.imagePublisher}"
  imageOffer = "${var.imageOffer}"
  imageSKU = "${var.imageSKU}"
  adminUsername = "${var.adminUsername}"
  adminPassword = "${var.adminPassword}"
  networkInterfaceIDSplat = "${module.nic.idSplat}"
  storageAccountPrimaryBlobEndpoint = "${var.storageAccountPrimaryBlobEndpoint}"
}

module "nic" {
  source = "../../resources/networkInterfaces"
  resourceGroupName = "${var.resourceGroupName}"
  location = "${var.location}"
  count = "${var.count}"
  name = "${var.name}-NIC"
  subnetID = "${var.subnetID}"
  publicIPAddressID = "${var.publicIPAddressID}"
}
