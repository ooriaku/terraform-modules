output "kv_cert_id" {
	value = azurerm_key_vault_certificate.certs.id
}
output "kv_cert_secret_id" {
	value = azurerm_key_vault_certificate.certs.secret_id
}

output "kv_cert_secret_version" {
	value = azurerm_key_vault_certificate.certs.version
}

output "kv_cert_name" {
	value = var.certificate_name
}


