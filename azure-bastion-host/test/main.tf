# - Resource Group Creation
resource "azurerm_resource_group" "rg" {
  name     = "testrg02"
  location = "uksouth"
}

#############################################################################
#   vnet Module is used to create Virtual Networks and Subnets for the Hub  #
#############################################################################
module "hub-vnet" {
    source              = "../../virtual-network"
    
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    vnet_name           = "vnet-test-hub"
    address_space       = ["10.200.0.0/22"]
    dns_servers         = ["10.200.0..4", "10.200.0..5", "168.63.129.16", "8.8.8.8"]  
    
   
    subnet_names = {     
      "A3-AzureBastionSubnet" = {
          subnet_name = "AzureBastionSubnet"
          address_prefixes = ["10.200.0.192/26"]
          route_table_name = ""
          snet_delegation  = ""
          service_endpoints= ""
          enforce_private_link_endpoint_network_policies = true   
          enforce_private_link_service_network_policies = false
      }
    }
    tags = {
    App = "testvnet"
  }
}

# publicip Module is used to create Public IP Address
module "bastion-pip" {
    source               = "../../public-ip-address"

    # Used for Azure Bastion 
    public_ip_name      = "pip-bastion-test"
    location                =   azurerm_resource_group.rg.location
    resource_group_name     =   azurerm_resource_group.rg.name
    allocation_method   = "Static"
    sku                 = "Standard"
    tags = {
        App = "testPublicIP"
    }
}

module "bastion-host" {
    source                  = "../"

    bastion_host_name       =   "testBasthost"
    sku                     =   "Standard"
    location                =   azurerm_resource_group.rg.location
    resource_group_name     =   azurerm_resource_group.rg.name
    ipconfig_name           =   "configuration"
    subnet_id               =   module.hub-vnet.vnet_subnet_id[0]
    public_ip_address_id    =   module.bastion-pip.public_ip_address_id   

    tags                    =   {
        App = "testBastion"
    }
}