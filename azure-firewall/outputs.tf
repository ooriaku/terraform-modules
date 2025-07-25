
output "firewall_name" {
	value = azurerm_firewall.fw.name
}
output "firewall_private_ip_address" {
	description = "Specifies the private IP address of the firewall."
	value = azurerm_firewall.fw.ip_configuration[0].private_ip_address
}