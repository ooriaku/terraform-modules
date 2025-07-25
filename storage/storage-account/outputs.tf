output "storage_id" {
  description = ""
  value       = azurerm_storage_account.storage-account.id
}

output "storage_primary_blob_endpoint" {
  description = ""
  value       = azurerm_storage_account.storage-account.primary_blob_endpoint
}

output "storage_primary_access_key" {
  description	= ""
  value			= azurerm_storage_account.storage-account.primary_access_key
  sensitive		= true
}

output "storage_primary_connection_string" {
  description = ""
  value       = azurerm_storage_account.storage-account.primary_connection_string
  sensitive   = true
}
output "storage_primary_queue_endpoint" {
  description = ""
  value       = azurerm_storage_account.storage-account.primary_queue_endpoint
}
output "storage_primary_table_endpoint" {
  description = ""
  value       = azurerm_storage_account.storage-account.primary_table_endpoint
}

output "storage_primary_file_endpoint" {
  description = ""
  value       = azurerm_storage_account.storage-account.primary_file_endpoint
}
output "storage_name" {
  description = ""
  value       = lower(azurerm_storage_account.storage-account.name)  
  
}

