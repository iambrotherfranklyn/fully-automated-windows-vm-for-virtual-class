resource "random_password" "password_generator" {
  for_each = toset(var.usernames)
  length   = 11
  lower    = true
  #numeric          = true
  special          = true
  upper            = true
  override_special = "!#%&"
}
