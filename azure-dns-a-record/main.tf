
resource "azurerm_private_dns_a_record" "dns-a-record" {

	name				= lower(var.azure_resource_name)
	zone_name			= var.private_dns_zone_name
	resource_group_name = var.resource_group_name
	ttl					= 300
	records				= [
							var.private_ip_address
	]

	tags		        = var.tags
}