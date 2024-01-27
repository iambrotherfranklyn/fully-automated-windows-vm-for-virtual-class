resource "random_password" "password_generator" {
  for_each = toset(var.usernames)
  length    = 11
  lower     = true
  upper     = true
  special   = true
  override_special = "!#%&"
  min_upper = 1  
  min_lower = 1  
  min_special = 1 
  
}
