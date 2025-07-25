output "namespace_id" {
  description = "Id of Event Hub Namespace."
  value       = module.eventhubnamespace.namespace_id
}

output "hub_ids" {
  description = "Map of hubs and their ids."
  value       = module.eventhubnamespace.hub_ids
}

output "keys" {
  description = "Map of hubs with keys => primary_key / secondary_key mapping."
  sensitive   = true
  value       = module.eventhubnamespace.keys
}

output "authorization_keys" {
  value = module.eventhubnamespace.authorization_keys
}