# 🔹 Private DNS Resolver in Hub
resource "azurerm_private_dns_resolver" "private-dns-resolver" {
    name                = var.private_dns_resolver_name
    resource_group_name = var.resource_group_name
    location            = var.location
    virtual_network_id  = var.virtual_network_id
    tags                = var.tags
}

# 🔹 Inbound Endpoint (Spokes Use This)
resource "azurerm_private_dns_resolver_inbound_endpoint" "private-dns-resolver-inbound-endpoint" {
  name                        = var.private_dns_resolver_inbound_endpoint_name
  private_dns_resolver_id     = azurerm_private_dns_resolver.private-dns-resolver.id
  location                    = var.location
   tags                    = var.tags
  ip_configurations {
    subnet_id = var.inbound_subnet_id
  }
}

# Creating one or multiple Outbound Endpoints based on input map, note there is currently only support for two outbound endpoints per DNS Resolver, and they cannot share the same subnet.
resource "azurerm_private_dns_resolver_outbound_endpoint" "private-dns-resolver-outbound-endpoint" {
  name                    = var.private_dns_resolver_outbound_endpoint_name
  private_dns_resolver_id = azurerm_private_dns_resolver.private-dns-resolver.id
  location                = var.location
  subnet_id               = var.outbound_subnet_id
  tags                    = var.tags
}