#Terraform block
terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }


  }
  ##Required version for terraform cli 
  required_version = "~> 1.4.6"

  #configuration in backend block to be used because terraform in running in azure pipeline
  # backend "azurerm" {

  # }
}

#Provider block
provider "azurerm" {
  #subscription_id = var.subscription_id
  #tenant_id       = var.tenant_id
 # client_id       = var.client_id
 # client_secret   = var.client_secret
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

provider "azuread" {}  