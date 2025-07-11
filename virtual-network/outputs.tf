output "vnet_id" {
  description = "The id of the newly created vNet"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "The Name of the newly created vNet"
  value       = azurerm_virtual_network.vnet.name
}

output "vnet_location" {
  description = "The location of the newly created vNet"
  value       = azurerm_virtual_network.vnet.location
}

output "vnet_address_space" {
  description = "The address space of the newly created vNet"
  value       = azurerm_virtual_network.vnet.address_space
}

output "vnet_subnet_id" {
  description = "The subnet Id of the newly created subnet"
  value       = values(azurerm_subnet.subnet)[*].id    
}

output "vnet_subnet_name" {
  description = "The subnet name of the newly created subnet"
  value       = values(azurerm_subnet.subnet)[*].name
}

output "vnet_subnet_address_prefix" {
  description = "The subnet address prefix of the newly created subnet"
  value       = values(azurerm_subnet.subnet)[*].address_prefixes
}