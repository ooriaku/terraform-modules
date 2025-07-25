data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
    name                            = var.key_vault_name
    location                        = var.location
    resource_group_name             = var.resource_group_name 
    tenant_id                       = data.azurerm_client_config.current.tenant_id
    sku_name                        = var.sku_name
    enabled_for_deployment          = var.enabled_for_deployment
    enabled_for_disk_encryption     = var.enabled_for_disk_encryption
    enabled_for_template_deployment = var.enabled_for_template_deployment
    tags		                    = var.tags

    network_acls {
        default_action = "Allow"
        bypass         = "AzureServices"
    }

    access_policy {
        object_id                = data.azurerm_client_config.current.object_id
        tenant_id                = data.azurerm_client_config.current.tenant_id

        certificate_permissions  = var.admin_certificate_permissions  
        key_permissions          = var.admin_key_permissions 
        secret_permissions       = var.admin_secret_permissions 
        storage_permissions      = var.admin_storage_permissions   

    }
 
    access_policy {
        object_id               = var.managed_identity_principal_id == "" ? null : var.managed_identity_principal_id
        tenant_id               = data.azurerm_client_config.current.tenant_id

        secret_permissions      = var.managed_identity_secret_permissions
        storage_permissions     = var.managed_identity_storage_permissions

        certificate_permissions = var.managed_identity_certificate_permissions  
        key_permissions         = var.managed_identity_key_permissions 
    }

}