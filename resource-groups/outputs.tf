﻿output "name" {
 value = azurerm_resource_group.rg.name
}

output "id" {
  value = azurerm_resource_group.rg.id 
}

output "location" { 
  value = azurerm_resource_group.rg.location
}