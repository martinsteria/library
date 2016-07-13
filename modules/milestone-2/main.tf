#milestone-2

variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "resourceGroupName" {}
variable "location" {}
variable "storageAccountName" {}
variable "storageAccountType" {}
variable "virtualNetworkName" {}
variable "virtualNetworkAddressSpace" {}
variable "subnetAdditionalBits" {}
variable "VMName" {}
variable "VMSize" {}
variable "imagePublisher" {}
variable "imageOffer" {}
variable "imageSKU" {}
variable "adminUsername" {}
variable "adminPassword" {}

provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id = "${var.client_id}"
  client_secret = "${var.client_secret}"
  tenant_id = "${var.tenant_id}"
}

resource "azurerm_resource_group" "RG" {
  name = "${var.resourceGroupName}"
  location = "${var.location}"
}

module "storageAccount" {
  source = "../resources/storageAccount"
  resourceGroupName = "${azurerm_resource_group.RG.name}"
  location = "${var.location}"
  name = "${var.storageAccountName}"
  type = "${var.storageAccountType}"
}

module "vnetWithSubnet" {
  source = "../modules/vnetWithSubnets"
  resourceGroupName = "${azurerm_resource_group.RG.name}"
  location = "${var.location}"
  name = "${var.virtualNetworkName}"
  addressSpace = "${var.virtualNetworkAddressSpace}"
  subnetAdditionalBits = "${var.subnetAdditionalBits}"
}

module "privateVMs" {
  source = "../modules/connectedVM"
  resourceGroupName = "${azurerm_resource_group.RG.name}"
  location = "${var.location}"
  count = "1"
  name = "${var.VMName}-private"
  subnetID = "${module.vnetWithSubnet.subnetIDSplat}"
  size = "${var.VMSize}"
  imagePublisher = "${var.imagePublisher}"
  imageOffer = "${var.imageOffer}"
  imageSKU = "${var.imageSKU}"
  adminUsername = "${var.adminUsername}"
  adminPassword = "${var.adminPassword}"
  storageAccountPrimaryBlobEndpoint = "${module.storageAccount.primaryBlobEndpoint}"
}

module "publicVM" {
  source = "../modules/publicVM"
  resourceGroupName = "${azurerm_resource_group.RG.name}"
  location = "${var.location}"
  name = "${var.VMName}-public"
  size = "${var.VMSize}"
  imagePublisher = "${var.imagePublisher}"
  imageOffer = "${var.imageOffer}"
  imageSKU = "${var.imageSKU}"
  adminUsername = "${var.adminUsername}"
  adminPassword = "${var.adminPassword}"
  storageAccountPrimaryBlobEndpoint = "${module.storageAccount.primaryBlobEndpoint}"
  subnetID = "${module.vnetWithSubnet.subnetIDSplat}"
}

output "ipAddress" {
    value = "${module.publicVM.publicIPAddress}"
}
