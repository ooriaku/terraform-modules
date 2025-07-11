output "web_app_name" {
  description = "The id of the newly created app service plan"
  value       = azurerm_windows_web_app.web.name
}

output "web_app_id" {
  description = "The id of the newly created app service plan"
  value       = azurerm_windows_web_app.web.id
}

output "web_app_host_name" {
  description = "The default_hostname of the newly created app service plan"
  value       = azurerm_windows_web_app.web.default_hostname
}
