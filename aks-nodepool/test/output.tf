output "aks_id" {
  value = module.aks.aks_id
}

output "location" {
  value = module.aks.location
}

output "pools" {
  value = module.nodepools.regular_node_pools_ids
}

output "spotpools" {
  value = module.nodepools.spot_node_pools_ids
}

output "node_pools" {
  value = module.nodepools.node_pools
}