

resource "azurerm_route_table" "rt" {  
    name                          = var.route_table_name
    location                      = var.location
    resource_group_name           = var.resource_group_name
    #disable_bgp_route_propagation = var.disable_bgp_route_propagation

   
    dynamic "route" {
        for_each = var.routes
        content {
            name                   = route.value.name
            address_prefix         = route.value.address_prefix
            next_hop_type          = route.value.next_hop_type
            next_hop_in_ip_address = route.value.next_hop_in_ip_address
        }
    }
    tags = merge(tomap({"type" = "network"}), var.tags)
    lifecycle {
        ignore_changes = [
            tags,
            route
        ]
    }
}

resource "azurerm_subnet_route_table_association" "spoke-to-firewall" {
    count          = length(var.subnet_ids)
    subnet_id      = var.subnet_ids[count.index]
    route_table_id = azurerm_route_table.rt.id
}