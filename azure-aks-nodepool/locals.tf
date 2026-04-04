locals {
  spot_node_pools = {
    for n in var.node_pools :
    n.name => {
      name                   = n.name
      vm_size                = lookup(n, "vm_size", var.vm_size)
      availability_zones     = lookup(n, "availability_zones", var.availability_zones)
      enable_auto_scaling    = lookup(n, "enable_auto_scaling", var.enable_auto_scaling)
      enable_host_encryption = false
      enable_node_public_ip  = lookup(n, "enable_node_public_ip", var.enable_node_public_ip)
      eviction_policy        = lookup(n, "eviction_policy", var.eviction_policy)
      max_pods               = lookup(n, "max_pods", var.max_pods)
      mode                   = lookup(n, "mode", var.mode)
      node_labels            = lookup(n, "node_labels", var.node_labels)
      node_taints            = lookup(n, "node_taints", var.node_taints)
      orchestrator_version   = lookup(n, "orchestrator_version", var.orchestrator_version)
      os_disk_size_gb        = lookup(n, "os_disk_size_gb", var.os_disk_size_gb)
      os_disk_type           = lookup(n, "os_disk_type", var.os_disk_type)
      os_type                = lookup(n, "os_type", var.os_type)
      priority               = lookup(n, "priority", var.priority)
      spot_max_price         = lookup(n, "spot_max_price", var.spot_max_price)
      tags                   = lookup(n, "tags", var.tags)
      max_count              = lookup(n, "max_count", var.max_count)
      min_count              = lookup(n, "min_count", var.min_count)
      node_count             = lookup(n, "node_count", var.node_count)
      max_surge              = lookup(n, "max_surge", var.max_surge)
      scale_down_mode        = lookup(n, "scale_down_mode", var.scale_down_mode)
      ultra_ssd_enabled      = lookup(n, "ultra_ssd_enabled", var.ultra_ssd_enabled)
      workload_runtime       = lookup(n, "workload_runtime", var.workload_runtime)
      windows_profile = merge({},
        try(var.windows_profile, {}),
        try(n.windows_profile, {}))
      kubelet_config = merge({},
        try(var.kubelet_config, {}),
        try(n.kubelet_config, {}))
      linux_os_config = merge({},
        try(var.linux_os_config,{}),
        try(n.linux_os_config, {}))
    } if n.priority == "Spot"
  }

  regular_node_pools = {
    for n in var.node_pools :
    n.name => {
      name                          = n.name
      vm_size                       = lookup(n, "vm_size", var.vm_size)
      availability_zones            = lookup(n, "availability_zones", var.availability_zones)
      enable_auto_scaling           = lookup(n, "enable_auto_scaling", var.enable_auto_scaling)
      enable_host_encryption        = false
      enable_node_public_ip         = lookup(n, "enable_node_public_ip", var.enable_node_public_ip)
      max_pods                      = lookup(n, "max_pods", var.max_pods)
      mode                          = lookup(n, "mode", var.mode)
      node_labels                   = lookup(n, "node_labels", var.node_labels)
      node_taints                   = lookup(n, "node_taints", var.node_taints)
      orchestrator_version          = lookup(n, "orchestrator_version", var.orchestrator_version)
      os_disk_size_gb               = lookup(n, "os_disk_size_gb", var.os_disk_size_gb)
      os_disk_type                  = lookup(n, "os_disk_type", var.os_disk_type)
      os_type                       = lookup(n, "os_type", var.os_type)
      priority                      = lookup(n, "priority", var.priority)
      tags                          = lookup(n, "tags", var.tags)
      max_count                     = lookup(n, "max_count", var.max_count)
      min_count                     = lookup(n, "min_count", var.min_count)
      node_count                    = lookup(n, "node_count", var.node_count)
      max_surge                     = lookup(n, "max_surge", var.max_surge)
      capacity_reservation_group_id = lookup(n, "capacity_reservation_group_id", var.capacity_reservation_group_id)
      host_group_id                 = lookup(n, "host_group_id", var.host_group_id)
      proximity_placement_group_id  = lookup(n, "proximity_placement_group_id", var.proximity_placement_group_id)
      kubelet_disk_type             = lookup(n, "kubelet_disk_type", var.kubelet_disk_type)
      node_public_ip_tags           = lookup(n, "node_public_ip_tags", var.node_public_ip_tags)
      node_public_ip_prefix_id      = lookup(n, "node_public_ip_prefix_id", var.node_public_ip_prefix_id)
      pod_subnet_id                 = lookup(n, "pod_subnet_id", var.pod_subnet_id)
      scale_down_mode               = lookup(n, "scale_down_mode", var.scale_down_mode)
      ultra_ssd_enabled             = lookup(n, "ultra_ssd_enabled", var.ultra_ssd_enabled)
      workload_runtime              = lookup(n, "workload_runtime", var.workload_runtime)
      windows_profile = merge({},
        try(var.windows_profile, {}),
        try(n.windows_profile, {}))
      kubelet_config = merge({},
        try(var.kubelet_config, {}),
        try(n.kubelet_config, {}))
      linux_os_config = merge({},
        try(var.linux_os_config,{}),
        try(n.linux_os_config, {}))
    } if n.priority == "Regular"
  }
}
