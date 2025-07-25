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
    vnet_name           = "vnet-test-aks"
    address_space       = ["10.200.0.0/16"]
    subnet_names = {
      "A0-AgwSubnet" = {
            subnet_name = "snet-test-aks"
            address_prefixes = ["10.200.0.0/26"] 
            snet_delegation  = ""        
        }
    }
}

module "msi" {
    source                  = "../../../managed-user-identity"
    resource_group_name     = azurerm_resource_group.testrg.name
    location                = azurerm_resource_group.testrg.location
    
    managed_identity_name   = "mi-test-aks"
    tags                    = {
        environment = "test"
        owner       = "Owen Oriaku"
        costCenter  = ""
        dr          = "no"
        approver    = "Owen Oriaku"
        managedBy   = "Owen Oriaku"
    }
}

module "aks_cluster" {
    source                               = "../../../azure-aks"
    count                                = 1

    

    cluster_name                        = "aks-cluster-test"
    resource_group_name                 = azurerm_resource_group.testrg.name
    location                            = azurerm_resource_group.testrg.location    
    resource_group_id                   = azurerm_resource_group.testrg.id
    
    kubernetes_version                   = "1.30.6"
    dns_prefix                           = "aks-test-dns"
    private_cluster_enabled              = true
    automatic_channel_upgrade            = "stable"
    sku_tier                             = "standard"
    default_node_pool                    = lookup(var.attr["aks"], "default_node_pool", {}) 
    additional_node_pools                = lookup(var.attr["aks"], "additional_node_pools", {}) 
    
    vnet_subnet_id                       = module.vnet.vnet_subnet_id[0]
    service_cidr                         = "10.200.1.0/26"
  
    network_plugin                       = "azure"
    network_policy                       = "azure"
    load_balancer_sku                    = "standard"
    acr_id                               = data.azurerm_container_registry.acr[0].id
    azure_rbac_enabled                   = true
    
    tags                    = {
        environment = "test"
        owner       = "Owen Oriaku"
        costCenter  = ""
        dr          = "no"
        approver    = "Owen Oriaku"
        managedBy   = "Owen Oriaku"
    }
    depends_on                               = [module.vnet]
}
