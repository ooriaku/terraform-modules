#Private Endpoints

resource "azurerm_private_endpoint" "private-endpoint" {
  name                = var.pvt_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  tags		            = merge(tomap({"type" = "network"}), var.tags)

  private_dns_zone_group {
    name                 = var.dns.zone_name
    private_dns_zone_ids = var.dns.zone_ids
  }

  private_service_connection {
    name                           = var.private_service_connection_name
    is_manual_connection           = var.is_manual_connection
    private_connection_resource_id = var.private_connection_resource_id
    subresource_names              = var.subresource_names
  }
}