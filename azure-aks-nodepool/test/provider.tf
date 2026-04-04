terraform {
  required_providers {}
  backend "azurerm" {}
}

provider "azurerm" {
  features {
    key_vault {
      recover_soft_deleted_key_vaults    = true
      purge_soft_delete_on_destroy       = false
      purge_soft_deleted_keys_on_destroy = false
    }
  }
}