resource "azurerm_virtual_network" "vnet" {
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  name                = "${var.vnet_name}"
  address_space       = "${var.address_space}"
  dns_servers         = "${var.dns_servers}"
  tags		            = merge(tomap({"type" = "network"}), var.tags)
}

resource "azurerm_subnet" "subnet" {
  for_each                                      = var.subnet_names
  
  name                                          = each.value.subnet_name
  virtual_network_name                          = azurerm_virtual_network.vnet.name
  resource_group_name                           = var.resource_group_name
  address_prefixes                              = each.value.address_prefixes
  private_endpoint_network_policies             = try(each.value.private_endpoint_network_policies, "Enabled")
 



dynamic "delegation" {
      for_each = { for delegate in var.delegations : delegate.name => delegate 
                    if each.value.snet_delegation == "aksservice" }
      content {
        name = "delegation-aksservice"
        service_delegation {
          name    = "Microsoft.ServiceNetworking/trafficControllers"
            actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
          }
      }
  }

  dynamic "delegation" {
      for_each = { for delegate in var.delegations : delegate.name => delegate 
                    if each.value.snet_delegation == "appservice" }
      content {
        name = "delegation-appService"
        service_delegation {
        name    = "Microsoft.Web/serverFarms"
          actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      }
  }

  dynamic "delegation" {
      for_each = { for delegate in var.delegations : delegate.name => delegate 
                    if each.value.snet_delegation == "devcentre" }
      content {
        name = "delegation-devCentre"
        service_delegation {
          name    = "Microsoft.DevCenter/networkConnections"
          actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      } 
  }
  dynamic "delegation" {
      for_each = { for delegate in var.delegations : delegate.name => delegate 
                    if each.value.snet_delegation == "mysql" }
      content {
        name = "delegation-database"
        service_delegation {
          name    = "Microsoft.DBforMySQL/flexibleServers"
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
          
        }
      }
  }
  dynamic "delegation" {
    for_each = { for delegate in var.delegations : delegate.name => delegate 
                    if each.value.snet_delegation == "aci" }
      content {
      name = "delegation-aci"
      service_delegation {
        name    = "Microsoft.ContainerInstance/containerGroups"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
  }
  dynamic "delegation" {
    for_each = { for delegate in var.delegations : delegate.name => delegate 
                    if each.value.snet_delegation == "dnsresolver" }
      content {
      name = "delegation-dnsResolver"
      service_delegation {
        name    = "Microsoft.Network/dnsResolvers"
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      }
    }
  }
  dynamic "delegation" {
    for_each = { for delegate in var.delegations : delegate.name => delegate 
                    if each.value.snet_delegation == "postgresql" }
      content {
      name = "delegation-fs"
      service_delegation {
        name    = "Microsoft.DBforPostgreSQL/flexibleServers"
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      }
    }
  }

  dynamic "delegation" {
    for_each = { for delegate in var.delegations : delegate.name => delegate 
                    if each.value.snet_delegation == "storage" }
      content {
      name = "delegation-storage"
      service_delegation {
        name    = "Microsoft.storage/storageAccounts"
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      }
    }
  }
}