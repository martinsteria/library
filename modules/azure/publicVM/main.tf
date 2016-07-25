#publicVM

variable "resourceGroupName" {}
variable "location" {}
variable "name" {}
variable "size" {}
variable "imagePublisher" {}
variable "imageOffer" {}
variable "imageSKU" {}
variable "adminUsername" {}
variable "adminPassword" {}
variable "storageAccountPrimaryBlobEndpoint" {}
variable "subnetID" {}

module "VM" {
  source = "../connectedVM"
  resourceGroupName = "${var.resourceGroupName}"
  location = "${var.location}"
  count = "1"
  name = "${var.name}"
  size = "${var.size}"
  imagePublisher = "${var.imagePublisher}"
  imageOffer = "${var.imageOffer}"
  imageSKU = "${var.imageSKU}"
  adminUsername = "${var.adminUsername}"
  adminPassword = "${var.adminPassword}"
  storageAccountPrimaryBlobEndpoint = "${var.storageAccountPrimaryBlobEndpoint}"
  subnetID = "${var.subnetID}"
  publicIPAddressID = "${module.publicIPAddress.id}"
}

module "publicIPAddress" {
  source = "../../../resources/azure_resources/dynamicIP"
  resourceGroupName = "${var.resourceGroupName}"
  location = "${var.location}"
  name = "${var.name}-ip"
}

output "publicIPAddress" {
  value = "${module.publicIPAddress.ipAddress}"
}
