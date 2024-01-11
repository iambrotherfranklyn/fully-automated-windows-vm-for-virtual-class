
 /*
resource "azuread_user" "users" {
  for_each = toset(var.usernames)

  user_principal_name   = "${each.key}@${var.user_principal_domain}"
  display_name          = each.key
  password              = var.user_password
  force_password_change = true
}

resource "azuread_group" "lab_user_group" {
  display_name     = var.aad_group_name
  security_enabled = true
  members          = [for user in azuread_user.users : user.object_id]
}

data "azurerm_role_definition" "vm_admin" {
  name = "Virtual Machine Administrator Login"
}

resource "azurerm_role_assignment" "user_role" {
  for_each = toset(var.usernames)

  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = data.azurerm_role_definition.vm_admin.name
  principal_id         = azuread_user.users[each.key].object_id
}


*/

# its-us@cybergees.com
# GeesCyber_Azure

#az login
#    Clear-Host
#    az account set --subscription "e243c19f-f5d7-4038-bdc7-a77ce40f79c3"
