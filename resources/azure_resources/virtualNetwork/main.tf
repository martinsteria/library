variable "location" {}
variable "resourceGroupName" {}
variable "name" {}
variable "addressSpace" {}

resource "azurerm_virtual_network" "vnet" {
    name = "${var.name}"
    resource_group_name = "${var.resourceGroupName}"
    location = "${var.location}"
    address_space = ["${var.addressSpace}"]
}

output "id" {
    value = "azurerm_virtual_network.vnet.id"
}
