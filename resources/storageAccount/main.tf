variable "resourceGroupName" {}
variable "location" {}
variable "name" {}
variable "type" {}

resource "azurerm_storage_account" "sa" {
    resource_group_name = "${var.resourceGroupName}"
    location = "${var.location}"
    name = "${var.name}"
    account_type = "${var.type}"
}

output "primaryBlobEndpoint" {
    value = "${azurerm_storage_account.sa.primary_blob_endpoint}"
}