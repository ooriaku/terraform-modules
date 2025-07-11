
 resource "azurerm_firewall_policy_rule_collection_group" "fw-coll-group" {
    name               = "rcg-${var.firewall_name}"
    firewall_policy_id = azurerm_firewall_policy.azfw-policy.id
    priority           = var.policy_priority
    
    dynamic "network_rule_collection" {
        for_each = var.network_rule_collections != null ? var.network_rule_collections : []
        content {
            name     = network_rule_collection.value.name
            priority = network_rule_collection.value.priority
            action   = network_rule_collection.value.action
    
            dynamic "rule" {
                for_each = can(network_rule_collection.value.rules) ? network_rule_collection.value.rules : []
                content {
                    name                  = rule.value.name
                    protocols             = rule.value.protocols
                    source_addresses      = rule.value.source_addresses
                    destination_addresses = rule.value.destination_addresses
                    destination_ports     = rule.value.destination_ports
                }
            }
        }
    }

    dynamic "application_rule_collection" {
        for_each = var.application_rule_collections != null ? var.application_rule_collections : []
        content {
            name     = application_rule_collection.value.name
            priority = application_rule_collection.value.priority
            action   = application_rule_collection.value.action
            dynamic "rule" {               
                for_each =  can(application_rule_collection.value.rules) ? application_rule_collection.value.rules : []
                content {
                    name = rule.value.name
                    dynamic "protocols" {
                        for_each = rule.value.protocols
                        content {
                            type = protocols.value.type
                            port = protocols.value.port
                        }
                    }
                    source_addresses      = rule.value.source_addresses                    
                    destination_fqdns     = rule.value.destination_fqdns
                }
            }
        }
    }

    dynamic "nat_rule_collection" {
        for_each = var.nat_rule_collections != null ? var.nat_rule_collections : []
        content {
            name     = nat_rule_collection.value.name
            priority = nat_rule_collection.value.priority
            action   = nat_rule_collection.value.action
    
            dynamic "rule" {
                for_each = can(nat_rule_collection.value.rules) ? nat_rule_collection.value.rules : []
                content {
                    name                  = rule.value.name
                    protocols             = rule.value.protocols
                    source_addresses      = rule.value.source_addresses
                    destination_address   = rule.value.destination_address                    
                    destination_ports     = rule.value.destination_ports
                    translated_address    = rule.value.translated_address
                    translated_port       = rule.value.translated_port
                }
            }
        }
    }
}


# Azure Firewall
resource "azurerm_firewall" "fw" {
    name                = var.firewall_name
    resource_group_name = var.resource_group_name
    location            = var.location
    sku_name            = var.firewall_sku_name               
    sku_tier            = var.firewall_sku_tier                #"Standard"
    zones               = var.zones
    threat_intel_mode   = var.threat_intel_mode
    
    ip_configuration {
        name                 = "azfw-ipconfig"
        subnet_id            = var.subnet_id
        public_ip_address_id = var.public_ip_address_id
    }
    firewall_policy_id = azurerm_firewall_policy.azfw-policy.id
    tags               = merge(tomap({"type" = "firewall"}), var.tags)

    lifecycle {
            ignore_changes = [
            tags,
            
            ]
    }

    depends_on  = [azurerm_firewall_policy.azfw-policy]
}


resource "azurerm_firewall_policy" "azfw-policy" {
    name                     = "policy-${var.firewall_name}"
    resource_group_name      = var.resource_group_name
    location                 = var.location
    sku                      = var.firewall_sku_tier
    

    lifecycle {
        ignore_changes = [
          tags
        ]
    }
}
