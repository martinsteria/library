variable "resourceGroupName" {}
variable "count" {
  default = "1"
}
variable "virtualNetworkName" {}
variable "virtualNetworkAddressSpace" {}
variable "additionalBits" {}

resource "azurerm_subnet" "subnet" {
  resource_group_name = "${var.resourceGroupName}"
  count = "${var.count}"
  name = "${var.virtualNetworkName}-subnet-${count.index}"
  virtual_network_name = "${var.virtualNetworkName}"
  address_prefix = "${cidrsubnet(var.virtualNetworkAddressSpace, var.additionalBits, count.index)}"
}

output "idSplat" {
  value = "${join(",", azurerm_subnet.subnet.*.id)}"
}
