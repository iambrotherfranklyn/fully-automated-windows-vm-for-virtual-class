data "azurerm_client_config" "cybergees_tenant_config" {}
resource "azurerm_key_vault" "cybergees_kv" {
  name                        = "cybergeeskeyvault12024"
  resource_group_name         = "${local.owners}-${var.resource_group_name}"
  location                    = azurerm_resource_group.cybergees_rg.location
  sku_name                    = "standard"
  tenant_id                   = data.azurerm_client_config.cybergees_tenant_config.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enabled_for_disk_encryption = true

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    #bypass                     = "none"
    ip_rules                   = ["0.0.0.0"]
    virtual_network_subnet_ids = []
  }
  timeouts {
    create = "30m"
    read   = "30m"
  }
  depends_on = [azurerm_resource_group.cybergees_rg]
}


resource "azurerm_key_vault_access_policy" "cybergees_kv_access_policy" {
  key_vault_id = azurerm_key_vault.cybergees_kv.id
  tenant_id    = data.azurerm_client_config.cybergees_tenant_config.tenant_id
  object_id = azurerm_user_assigned_identity.cybergees_user_assigned_identity.principal_id

  secret_permissions = [
    "Get",
  ]
depends_on = [azurerm_key_vault.cybergees_kv]
}

resource "azurerm_key_vault_access_policy" "terraform" {
  key_vault_id = azurerm_key_vault.cybergees_kv.id
  tenant_id    = data.azurerm_client_config.cybergees_tenant_config.tenant_id
  object_id    = "9131aeb9-d0f1-40a9-921e-433e0ff57bc4"
  #object_id    = "6bc2545f-43ef-4b56-9147-1dd795346aef"  

  secret_permissions = [
     "Get",
     "List",
     "Set",
     "Delete",
     "Recover",
     "Backup",
     "Restore",
     "Purge"
  ]
 depends_on = [azurerm_key_vault.cybergees_kv]
}

#mine
resource "azurerm_key_vault_access_policy" "cybergees_kv_access_policy_for_admin" {
  key_vault_id = azurerm_key_vault.cybergees_kv.id
  tenant_id    = data.azurerm_client_config.cybergees_tenant_config.tenant_id
  object_id    = "dd509e4c-8bb0-4a65-99e9-df109bd76d8e" 

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
  ]
depends_on = [azurerm_key_vault.cybergees_kv]
}


resource "azurerm_key_vault_secret" "vm_secret" {
  for_each     = random_password.password_generator
  name         = "vm-password-for-${each.key}"
  value        = each.value.result
  key_vault_id = azurerm_key_vault.cybergees_kv.id
  depends_on = [azurerm_key_vault_access_policy.terraform]
}



