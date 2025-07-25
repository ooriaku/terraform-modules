output "pe_id" {
  description = "The id of the newly created private endpoint"
  value       = azurerm_private_endpoint.private-endpoint.id
}

output "pe_private_ip" {
  value = azurerm_private_endpoint.private-endpoint.private_service_connection[0].private_ip_address
}

output "pe_name" {
	value       = azurerm_private_endpoint.private-endpoint.name
}

output "pe_resource_group_name" {
	value       = azurerm_private_endpoint.private-endpoint.resource_group_name
}
