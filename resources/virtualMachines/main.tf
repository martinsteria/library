# AzureRM Virtual Machine

/**
This module creates 'n' virtual machines for the Azure cloud.
*/

variable "resourceGroupName" {
  description = "The name of the resource group containing the VM"
}
variable "location" {
  description = "The geographical location of the VM"
}
variable "count" {
  default = "1"
  description = "The number of VM instances to create"
}
variable "name" {
  description = "The name of the VM"
}
variable "size" {
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
variable "networkInterfaceIDSplat" {
  description = "A string of network interface IDs separated by commas"
}
variable "storageAccountPrimaryBlobEndpoint" {
  description = "The storage account primary blob endpoint used to store the VM"
}

resource "azurerm_virtual_machine" "vm" {
  count = "${var.count}"
  resource_group_name = "${var.resourceGroupName}"
  location = "${var.location}"
  name = "${var.name}-${count.index}"
  vm_size = "${var.size}"
  storage_image_reference {
    publisher = "${var.imagePublisher}"
    offer = "${var.imageOffer}"
    sku = "${var.imageSKU}"
    version = "latest"
  }
  storage_os_disk {
    name = "${var.name}-${count.index}-osdisk"
    vhd_uri = "${var.storageAccountPrimaryBlobEndpoint}vhds/${var.name}-${count.index}-osdisk.vhd"
    caching = "ReadWrite"
    create_option = "FromImage"
  }
  os_profile {
    computer_name = "${var.name}-${count.index}"
    admin_username = "${var.adminUsername}"
    admin_password = "${var.adminPassword}"
  }

  network_interface_ids = ["${element(split(",", var.networkInterfaceIDSplat), count.index)}"]
}

