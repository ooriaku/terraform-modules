resource "azurerm_resource_group" "testrg" {
  name     = "testrg"
  location = "UK South"
}

module "vnet" {
    source              = "../../../virtual-network"

    resource_group_name = azurerm_resource_group.testrg.name
    location            = azurerm_resource_group.testrg.location
    tags                = {
        environment = "test"
        owner       = "Owen Oriaku"
        costCenter  = ""
        dr          = "no"
        approver    = "Owen Oriaku"
        managedBy   = "Owen Oriaku"
    }
    vnet_name           = "vnet-test-agw"
    address_space       = ["10.200.0.0/16"]
    subnet_names = {
      "A0-AgwSubnet" = {
            subnet_name = "snet-test-agw"
            address_prefixes = ["10.200.0.0/26"] 
            snet_delegation  = ""        
        }
    }
}

module "agw-pip" {
    source              = "../../../public-ip-address"

    # Used for application Gateway 
    public_ip_name      = "pip-test-agw"
    resource_group_name = azurerm_resource_group.testrg.name
    location            = azurerm_resource_group.testrg.location
    allocation_method   = "Static"
    sku                 = "Standard"
    tags                = {
        environment = "test"
        owner       = "Owen Oriaku"
        costCenter  = ""
        dr          = "no"
        approver    = "Owen Oriaku"
        managedBy   = "Owen Oriaku"
    }
}
module "msi" {
    source                  = "../../../managed-user-identity"
    resource_group_name     = azurerm_resource_group.testrg.name
    location                = azurerm_resource_group.testrg.location
    
    managed_identity_name   = "mi-test-agw"
    tags                    = {
        environment = "test"
        owner       = "Owen Oriaku"
        costCenter  = ""
        dr          = "no"
        approver    = "Owen Oriaku"
        managedBy   = "Owen Oriaku"
    }
}

module "key-vault" {
    source              = "../../../key-vault"

    resource_group_name = azurerm_resource_group.testrg.name
    location            = azurerm_resource_group.testrg.location
    key_vault_name      = "kv-test-agw"
   
    sku_name                        = "standard"
    admin_certificate_permissions   = ["Create",
											  "Delete",
											  "DeleteIssuers",
											  "Get",
											  "GetIssuers",
											  "Import",
											  "List",
											  "ListIssuers",
											  "ManageContacts",
											  "ManageIssuers",
											  "Purge",
											  "SetIssuers",
											  "Update"
											]
    admin_key_permissions           = ["Backup",
											  "Create",
											  "Decrypt",
											  "Delete",
											  "Encrypt",
											  "Get",
											  "Import",
											  "List",
											  "Purge",
											  "Recover",
											  "Restore",
											  "Sign",
											  "UnwrapKey",
											  "Update",
											  "Verify",
											  "WrapKey"
											]
    admin_secret_permissions        = ["Backup",
											  "Delete",
											  "Get",
											  "List",
											  "Purge",
											  "Restore",
											  "Set"
											] 
    admin_storage_permissions       = []
    managed_identity_name           = "mi-test-agw" 
    managed_identity_secret_permissions = ["Get"]
    managed_identity_storage_permissions = []
    managed_identity_certificate_permissions = ["Get", "List"]
    managed_identity_key_permissions = ["Get", "List"]
    managed_identity_principal_id   = module.msi.user_assigned_principal_id
    tags = {
        environment = "test"
        owner       = "Owen Oriaku"
        costCenter  = ""
        dr          = "no"
        approver    = "Owen Oriaku"
        managedBy   = "Owen Oriaku"
    }
    depends_on                      = [module.msi]
}



module "self-certs" {
    source              = "../../../key-vault-certs"
    
    key_vault_id        = module.key-vault.kv_id
    key_vault_name      = module.key-vault.kv_name
    certificate_name    = "test-cert"
    subject             = "test-cert"
    dns_names           = ["example-webapp.azurewebsites.net"]  # Replace with your web app's FQDN
    validity_in_months  = 12
    days_before_expiry  = 30    
}

module "application-gateway" {
    source                      = "../../../load-balancers/application-gateway"   
    
   
    resource_group_name         = azurerm_resource_group.testrg.name
    location                    = azurerm_resource_group.testrg.location
    app_gateway_name            = "agw-test" 
   
    enable_http2                = true
    
    zones                       = []
    subnet_id                   = module.vnet.vnet_subnet_id[0] # This should be the subnet where the Application Gateway is deployed   
    public_ip_address_id        = module.agw-pip.public_ip_address_id
    identity_ids                = [module.msi.user_assigned_identity_id] 
    sku = {
        # Accpected value for names Standard_v2 and WAF_v2
        name = "Standard_v2"
        # Accpected value for tier Standard_v2 and WAF_v2
        tier = "Standard_v2"

        # Accpected value for capacity 1 to 10 for a V1 SKU, 1 to 100 for a V2 SKU
        capacity = 1
    }
 
    backend_address_pools = {
        pool1 = {
            name = "web-backend-pool"
            # Use the private IP address of the web app or the FQDN if using a private DNS zone
            backend_addresses = [
                {
                    fqdn = "http://example-webapp.azurewebsites.net"  # Replace with your web app's FQDN
                }
            ]
        }
    }

    backend_http_settings = {        
        setting1 =  {
            name                  = "http-settings-1"
            cookie_based_affinity = "Disabled"
            path                  = "/"
            enable_https          = false
            request_timeout       = 30
            connection_draining = {
                enable_connection_draining = true
                drain_timeout_sec          = 300
            }
        },
        setting2 = {
            name                  = "https-settings-2"
            cookie_based_affinity = "Disabled"
            path                  = "/"
            enable_https          = true
            request_timeout       = 30
            connection_draining = {
                enable_connection_draining = true
                drain_timeout_sec          = 300
            }
        }
    }

    http_listeners = [
        {
            name                 = "https-listener"
            host_name            = null            
            ssl_certificate_name = "${module.self-certs.kv_cert_name}"
            ssl_profile_name     = "test-ssl-profile"
        },
        {
            name                 = "http-listener"
            host_name            = null    
        }
    ]

    request_routing_rules = {
        rule1 = {
            name                        = "routing-rule"
            priority                    = 100
            rule_type                   = "Basic"
            http_listener_name          = "https-listener"
            backend_address_pool_name   = "web-backend-pool"
            backend_http_settings_name  = "https-settings-2"

        }
    }

    depends_on = [ module.vnet, module.agw-pip ]
}