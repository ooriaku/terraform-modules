output "namespace_id" {
  description = "Id of Event Hub Namespace."
  value       = azurerm_eventhub_namespace.ehn.id
}

output "hub_ids" {
  description = "Map of hubs and their ids."
  value       = { for k, v in azurerm_eventhub.ehub : k => v.id }
}

output "keys" {
  description = "Map of hubs with keys => primary_key / secondary_key mapping."
  sensitive   = true
  value = { for k, h in azurerm_eventhub_authorization_rule.ehub_rule : h.name => {
    primary_key   = h.primary_key
    secondary_key = h.secondary_key
    }
  }
}

output "authorization_keys" {
  description = "Map of authorization keys with their ids."
  value       = { for a in azurerm_eventhub_namespace_authorization_rule.ehn_rule : a.name => a.id }
}