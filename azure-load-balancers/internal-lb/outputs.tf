# LB Private IP Address List
output "app_lb_private_ip_addresses" {
  description = "Load Balancer Public Address"
  value = [azurerm_lb.app-lb.private_ip_addresses]
}

# Load Balancer ID
output "app_lb_id" {
  description = "The Internal Load Balancer ID."
  value = azurerm_lb.app-lb.id 
}

# Load Balancer Frontend IP Configuration Block
output "app_lb_frontend_ip_configuration" {
  description = "LB frontend_ip_configuration Block"
  value = [azurerm_lb.app-lb.frontend_ip_configuration]
}

output "app_lb_resource_group_name" {
  description = "The Internal Load Balancer resource_group_name."
  value = var.resource_group_name 
}

output "app_lb_name" {
  description = "The Internal Load Balancer name."
  value = azurerm_lb.app-lb.name 
}