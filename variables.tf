variable "usernames" {
  description = "List of usernames"
  type        = list(string)
  #default     = ["brothersake"]
  default     = ["frank", "sake", "ali", "kunle", "obi", "ada", "admin", "bisi", "ola", "chuks"]
}

variable "owners" {
  description = "The owner of the resources."
  type        = string
  default     = "cyber-gees"
}

variable "environment" {
  description = "The deployment environment."
  type        = string
  default     = "students"
}

#variable "usernames" {
# description = "List of usernames for creating resources"
# type        = list(string)
#default     = []
#}

#variable "admin_username" {
# description = "Admin username for the Linux virtual machines"
# type        = string
# default     = "adminuser"
#}

variable "vm_size" {
  description = "The size of the virtual machine"
  type        = string
  default     = "Standard_F2"
}

variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "students-rg"
}

variable "location" {
  description = "Azure region for the resource group"
  type        = string
  default     = "UK South"
}

variable "vnet_name" {
  description = "Name of the Azure virtual network"
  type        = string
  default     = "students-vnet"
}

variable "vnet_address_space" {
  description = "Address space for the Azure virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "Name of the Azure subnet"
  type        = string
  default     = "students-subnet"
}

variable "subnet_address_prefixes" {
  description = "Address prefixes for the Azure subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "public_ip_name" {
  description = "Name of the Azure public IP"
  type        = string
  default     = "student-public-ip"
}

variable "nsg_name" {
  description = "Name of the Azure network security group"
  type        = string
  default     = "students-subnet-nsg"
}

variable "user_principal_domain" {
  description = "Domain for the user principal names"
  type        = string
  default     = "put yous"
}

variable "user_password" {
  description = "Initial password for the Azure AD users"
  type        = string
  default     = "store in keyvault"
}

variable "aad_group_name" {
  description = "Name of the Azure AD group"
  type        = string
  default     = "student-group"
}

variable "vm_admin_username" {
  description = "Admin username for the virtual machines"
  type        = string
  default     = "adminuser"
}

variable "vm_admin_password" {
  description = "Admin password for the virtual machines"
  type        = string
  default     = "storein1keyvault!"

}

variable "subscription_id" {
  description = "The Subscription ID for Azure"
  type        = string
  default     = "store in keyvault"
}

variable "tenant_id" {
  description = "The Tenant ID for Azure"
  type        = string
  default     = "store in keyvault"
}

variable "client_id" {
  description = "The Client ID for Azure"
  type        = string
  default     = "store in keyvault"
}

variable "client_secret" {
  description = "The Client Secret for Azure"
  type        = string
  default     = "store in keyvault"
}






