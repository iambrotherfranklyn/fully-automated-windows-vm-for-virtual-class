resource "azurerm_resource_group" "cybergees_rg" {
  name     = "${local.owners}-${var.resource_group_name}"
  location = var.location
}
