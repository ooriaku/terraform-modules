# Create a load balancer
resource "azurerm_lb" "app-lb" {
    #count               = var.enabled ? 1 : 0

    name                = "${var.lb_name}"
    location            = "${var.location}"
    resource_group_name = "${var.resource_group_name}"
    sku                 = "Standard"
    tags                = var.tags

    frontend_ip_configuration {
        name                 = "${var.lb_name}-internal"
        subnet_id            = "${var.subnet_id}"   
        private_ip_address_allocation   = var.private_ip_address_allocation          #"Dynamic"
        private_ip_address_version      = "IPv4"
        private_ip_address              = var.private_ip_address_allocation == "Dynamic" ? null : var.private_ip_address
    }  
}

# Resource-3: Create LB Backend Pool
resource "azurerm_lb_backend_address_pool" "app-lb-backend-address-pool" {
    name                = "${var.lb_name}-pool"
    loadbalancer_id     = azurerm_lb.app-lb.id
}

# Resource-4: Create LB Probe
resource "azurerm_lb_probe" "app-lb-probe" {
    name                = "tcp-probe"
    protocol            = "Tcp"
    port                = 80
    loadbalancer_id     = azurerm_lb.app-lb.id 

}

# Resource-5: Create LB Rule
resource "azurerm_lb_rule" "lb-http-rule" {
    name                           = "http-rule"
    protocol                       = "Tcp"
    frontend_port                  = 80
    backend_port                   = 80
    frontend_ip_configuration_name = azurerm_lb.app-lb.frontend_ip_configuration[0].name
    backend_address_pool_ids       = [azurerm_lb_backend_address_pool.app-lb-backend-address-pool.id]
    probe_id                       = azurerm_lb_probe.app-lb-probe.id
    loadbalancer_id                = azurerm_lb.app-lb.id
}


  resource "azurerm_network_interface_backend_address_pool_association" "lb-nic-associate" {
    count                   =  "${length(var.network_interface_ids)}"

    network_interface_id    =  "${element(var.network_interface_ids, count.index)}"
    ip_configuration_name   =  "${element(var.ip_configuration_names, count.index)}"
    backend_address_pool_id =   azurerm_lb_backend_address_pool.app-lb-backend-address-pool.id
  }