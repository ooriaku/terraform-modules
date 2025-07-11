output "kv_id" {
    description = "Key vault Resource ID"
    value = azurerm_key_vault.kv.id
}

output "kv_name" {
    description = "Key vault Resource name"
    value = azurerm_key_vault.kv.name
}

output "key_vault_url" {
  description = "Key Vault URI"
  value       = azurerm_key_vault.kv.vault_uri
}