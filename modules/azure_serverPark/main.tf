#Server Park

/*
Module Description = The server park module creates a given number of virtual machines with one of them connected to a public IP-address
*/

variable "subscription_id" {
  description = "The Subscription id of your Azure account"
}
variable "client_id" {
  description = "The client id of your Azure account"
}
variable "client_secret" {
  description = "The client secret of your Azure account"
}
variable "tenant_id" {
  description = "The tenant id of your Azure account"
}
variable "resourceGroupName" {
  description = "The name of the resource group containing the VM"
}
variable "location" {
  description = "The geographical location of the VM"
}
variable "storageAccountName" {
  description = "Name of the storage account. Must be unique in Azure"
}
variable "storageAccountType" {
  description = "The type of the storage account"
}
variable "virtualNetworkName" {
  description = "The name of the virtual network"
}
variable "virtualNetworkAddressSpace" {
 description = "The address space of the virtual network"
}
variable "subnetAdditionalBits" {
  description = "Additional bits used by subnets"
}
variable "privateVMCount" {
  description = "The number of private virtual machines"
  default = "1"
}
variable "VMName" {
  description = "The name of the VM"
}
variable "VMSize" {
  description = "The size of the storage for the VM"
}
variable "imagePublisher" {
  description = "The publisher of the OS image for the VM"
}
variable "imageOffer" {
  description = "The offer of the OS image for the VM"
}
variable "imageSKU" {
  description = "The SKU of the OS image for the VM"
}
variable "adminUsername" {
  description = "The admin username for the VM"
}
variable "adminPassword" {
  description = "The admin password for the VM"
}

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
  source = "../../resources/storageAccount"
  resourceGroupName = "${azurerm_resource_group.RG.name}"
  location = "${var.location}"
  name = "${var.storageAccountName}"
  type = "${var.storageAccountType}"
}

module "vnetWithSubnet" {
  source = "../vnetWithSubnets"
  resourceGroupName = "${azurerm_resource_group.RG.name}"
  location = "${var.location}"
  name = "${var.virtualNetworkName}"
  addressSpace = "${var.virtualNetworkAddressSpace}"
  subnetAdditionalBits = "${var.subnetAdditionalBits}"
}

module "privateVMs" {
  source = "../connectedVM"
  resourceGroupName = "${azurerm_resource_group.RG.name}"
  location = "${var.location}"
  count = "${var.privateVMCount}"
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
  source = "../publicVM"
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
  /*
  Output Description = "The public IP-address of the server park"
  */
  value = "${module.publicVM.publicIPAddress}"
}
