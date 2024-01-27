resource "azurerm_user_assigned_identity" "cybergees_user_assigned_identity" {
  resource_group_name = "${local.owners}-${var.resource_group_name}"
  location            = azurerm_resource_group.cybergees_rg.location
  name                = "cybergees-user-assinged-identity"
  depends_on          = [azurerm_resource_group.cybergees_rg]
}

resource "azurerm_role_assignment" "cybergees_kv_role" {
  scope                = azurerm_key_vault.cybergees_kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = azurerm_user_assigned_identity.cybergees_user_assigned_identity.principal_id
  depends_on           = [azurerm_user_assigned_identity.cybergees_user_assigned_identity]
}