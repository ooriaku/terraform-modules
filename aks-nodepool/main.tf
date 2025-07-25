resource "azurerm_kubernetes_cluster_node_pool" "spot" {
  for_each = local.spot_node_pools

  # lifecycle {
  #   ignore_changes = [
  #     node_count,
  #     tags
  #   ]
  # }

  kubernetes_cluster_id = var.kubernetes_cluster_id
  vnet_subnet_id        = var.vnet_subnet_id

  name                   = each.value.name
  vm_size                = each.value.vm_size
  zones                  = each.value.availability_zones
  enable_auto_scaling    = each.value.enable_auto_scaling
  enable_host_encryption = each.value.enable_host_encryption
  enable_node_public_ip  = each.value.enable_node_public_ip
  eviction_policy        = each.value.eviction_policy
  max_pods               = each.value.max_pods
  mode                   = each.value.mode
  node_labels            = each.value.node_labels
  node_taints            = each.value.node_taints
  orchestrator_version   = each.value.orchestrator_version
  os_disk_size_gb        = each.value.os_disk_size_gb
  os_disk_type           = each.value.os_disk_type
  os_type                = each.value.os_type
  priority               = each.value.priority
  spot_max_price         = each.value.spot_max_price
  tags                   = each.value.tags
  max_count              = each.value.max_count
  min_count              = each.value.min_count
  node_count             = each.value.node_count
  kubelet_disk_type      = each.value.kubelet_disk_type
  pod_subnet_id          = each.value.pod_subnet_id

  node_public_ip_prefix_id = each.value.enable_node_public_ip ? each.value.node_public_ip_prefix_id : null


  dynamic "kubelet_config" {
    for_each = each.value.kubelet_config == {} ? [] : ["kubelet_config"]
    content {
      allowed_unsafe_sysctls    = try(each.value.kubelet_config.allowed_unsafe_sysctls, null)
      container_log_max_line    = try(each.value.kubelet_config.container_log_max_line, null)
      container_log_max_size_mb = try(each.value.kubelet_config.container_log_max_size_mb, null)
      cpu_cfs_quota_enabled     = try(each.value.kubelet_config.cpu_cfs_quota_enabled, null)
      cpu_cfs_quota_period      = try(each.value.kubelet_config.cpu_cfs_quota_period, null)
      cpu_manager_policy        = try(each.value.kubelet_config.cpu_manager_policy, null)
      image_gc_high_threshold   = try(each.value.kubelet_config.image_gc_high_threshold, null)
      image_gc_low_threshold    = try(each.value.kubelet_config.image_gc_low_threshold, null)
      pod_max_pid               = try(each.value.kubelet_config.pod_max_pid, null)
      topology_manager_policy   = try(each.value.kubelet_config.topology_manager_policy, null)
    }
  }

  dynamic "linux_os_config" {
    for_each = each.value.linux_os_config == {} ? [] : ["linux_os_config"]
    content {
      swap_file_size_mb = try(each.value.linux_os_config.swap_file_size_mb, null)
      transparent_huge_page_defrag = try(each.value.linux_os_config.transparent_huge_page_defrag, null)
      transparent_huge_page_enabled = try(each.value.linux_os_config.transparent_huge_page_enabled, null)
      dynamic "sysctl_config" {
        for_each = each.value.linux_os_config.sysctl_config == {} ? [] : ["sysctl_config"]
        content {
          fs_aio_max_nr = try(each.value.linux_os_config.sysctl_config.fs_aio_max_nr, null)
          fs_file_max = try(each.value.linux_os_config.sysctl_config.fs_file_max, null)
          fs_inotify_max_user_watches = try(each.value.linux_os_config.sysctl_config.fs_inotify_max_user_watches, null)
          fs_nr_open = try(each.value.linux_os_config.sysctl_config.fs_nr_open, null)
          kernel_threads_max = try(each.value.linux_os_config.sysctl_config.kernel_threads_max, null)
          net_core_netdev_max_backlog = try(each.value.linux_os_config.sysctl_config.net_core_netdev_max_backlog, null)
          net_core_optmem_max = try(each.value.linux_os_config.sysctl_config.net_core_optmem_max, null)
          net_core_rmem_default = try(each.value.linux_os_config.sysctl_config.net_core_rmem_default, null)
          net_core_rmem_max = try(each.value.linux_os_config.sysctl_config.net_core_rmem_max, null)
          net_core_somaxconn = try(each.value.linux_os_config.sysctl_config.net_core_somaxconn, null)
          net_core_wmem_default = try(each.value.linux_os_config.sysctl_config.net_core_wmem_default, null)
          net_core_wmem_max = try(each.value.linux_os_config.sysctl_config.net_core_wmem_max, null)
          net_ipv4_ip_local_port_range_max = try(each.value.linux_os_config.sysctl_config.net_ipv4_ip_local_port_range_max, null)
          net_ipv4_ip_local_port_range_min = try(each.value.linux_os_config.sysctl_config.net_ipv4_ip_local_port_range_min, null)
          net_ipv4_neigh_default_gc_thresh1 = try(each.value.linux_os_config.sysctl_config.net_ipv4_neigh_default_gc_thresh1, null)
          net_ipv4_neigh_default_gc_thresh2 = try(each.value.linux_os_config.sysctl_config.net_ipv4_neigh_default_gc_thresh2, null)
          net_ipv4_neigh_default_gc_thresh3 = try(each.value.linux_os_config.sysctl_config.net_ipv4_neigh_default_gc_thresh3, null)
          net_ipv4_tcp_fin_timeout = try(each.value.linux_os_config.sysctl_config.net_ipv4_tcp_fin_timeout, null)
          net_ipv4_tcp_keepalive_intvl = try(each.value.linux_os_config.sysctl_config.net_ipv4_tcp_keepalive_intvl, null)
          net_ipv4_tcp_keepalive_probes = try(each.value.linux_os_config.sysctl_config.net_ipv4_tcp_keepalive_probes, null)
          net_ipv4_tcp_keepalive_time = try(each.value.linux_os_config.sysctl_config.net_ipv4_tcp_keepalive_time, null)
          net_ipv4_tcp_max_syn_backlog = try(each.value.linux_os_config.sysctl_config.net_ipv4_tcp_max_syn_backlog, null)
          net_ipv4_tcp_max_tw_buckets = try(each.value.linux_os_config.sysctl_config.net_ipv4_tcp_max_tw_buckets, null)
          net_ipv4_tcp_tw_reuse = try(each.value.linux_os_config.sysctl_config.net_ipv4_tcp_tw_reuse, null)
          net_netfilter_nf_conntrack_buckets = try(each.value.linux_os_config.sysctl_config.net_netfilter_nf_conntrack_buckets, null)
          net_netfilter_nf_conntrack_max = try(each.value.linux_os_config.sysctl_config.net_netfilter_nf_conntrack_max, null)
          vm_max_map_count = try(each.value.linux_os_config.sysctl_config.vm_max_map_count, null)
          vm_swappiness = try(each.value.linux_os_config.sysctl_config.vm_swappiness, null)
        }
      }
    }
  }
  
  dynamic "node_network_profile" {
    for_each = each.value.node_public_ip_tags == null ? [] : ["node_public_ip_tags"]
    content {
      node_public_ip_tags = each.value.node_public_ip_tags
    }
  }

  dynamic "upgrade_settings" {
    for_each = each.value.max_surge == null ? [] : ["upgrade_settings"]
    content {
      max_surge = each.value.max_surge
    }
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "regular" {
  for_each = local.regular_node_pools

  kubernetes_cluster_id = var.kubernetes_cluster_id
  vnet_subnet_id        = var.vnet_subnet_id

  name                   = each.value.name
  vm_size                = each.value.vm_size
  zones                  = each.value.availability_zones
  enable_auto_scaling    = each.value.enable_auto_scaling
  enable_host_encryption = each.value.enable_host_encryption
  enable_node_public_ip  = each.value.enable_node_public_ip
  max_pods               = each.value.max_pods
  mode                   = each.value.mode
  node_labels            = each.value.node_labels
  node_taints            = each.value.node_taints
  orchestrator_version   = each.value.orchestrator_version
  os_disk_size_gb        = each.value.os_disk_size_gb
  os_disk_type           = each.value.os_disk_type
  os_type                = each.value.os_type
  priority               = each.value.priority
  tags                   = each.value.tags
  max_count              = each.value.max_count
  min_count              = each.value.min_count
  node_count             = each.value.node_count
  kubelet_disk_type      = each.value.kubelet_disk_type

  capacity_reservation_group_id = each.value.capacity_reservation_group_id
  host_group_id                 = each.value.host_group_id
  node_public_ip_prefix_id      = each.value.enable_node_public_ip ? each.value.node_public_ip_prefix_id : null
  proximity_placement_group_id  = each.value.proximity_placement_group_id
  scale_down_mode  = each.value.scale_down_mode
  ultra_ssd_enabled  = each.value.ultra_ssd_enabled
  workload_runtime  = each.value.workload_runtime

  dynamic "windows_profile" {
    for_each = each.value.windows_profile == {} ? [] : ["windows_profile"]
    content {
      outbound_nat_enabled = try(each.value.windows_profile.outbound_nat_enabled, null)
    }
  }

  dynamic "kubelet_config" {
    for_each = each.value.kubelet_config == {} ? [] : ["kubelet_config"]
    content {
      allowed_unsafe_sysctls    = try(each.value.kubelet_config.allowed_unsafe_sysctls, null)
      container_log_max_line    = try(each.value.kubelet_config.container_log_max_line, null)
      container_log_max_size_mb = try(each.value.kubelet_config.container_log_max_size_mb, null)
      cpu_cfs_quota_enabled     = try(each.value.kubelet_config.cpu_cfs_quota_enabled, null)
      cpu_cfs_quota_period      = try(each.value.kubelet_config.cpu_cfs_quota_period, null)
      cpu_manager_policy        = try(each.value.kubelet_config.cpu_manager_policy, null)
      image_gc_high_threshold   = try(each.value.kubelet_config.image_gc_high_threshold, null)
      image_gc_low_threshold    = try(each.value.kubelet_config.image_gc_low_threshold, null)
      pod_max_pid               = try(each.value.kubelet_config.pod_max_pid, null)
      topology_manager_policy   = try(each.value.kubelet_config.topology_manager_policy, null)
    }
  }
  dynamic "linux_os_config" {
    for_each = each.value.linux_os_config == {} ? [] : ["linux_os_config"]
    content {
      swap_file_size_mb = try(each.value.linux_os_config.swap_file_size_mb, null)
      transparent_huge_page_defrag = try(each.value.linux_os_config.transparent_huge_page_defrag, null)
      transparent_huge_page_enabled = try(each.value.linux_os_config.transparent_huge_page_enabled, null)
      dynamic "sysctl_config" {
        for_each = each.value.linux_os_config.sysctl_config == {} ? [] : ["sysctl_config"]
        content {
          fs_aio_max_nr = try(each.value.linux_os_config.sysctl_config.fs_aio_max_nr, null)
          fs_file_max = try(each.value.linux_os_config.sysctl_config.fs_file_max, null)
          fs_inotify_max_user_watches = try(each.value.linux_os_config.sysctl_config.fs_inotify_max_user_watches, null)
          fs_nr_open = try(each.value.linux_os_config.sysctl_config.fs_nr_open, null)
          kernel_threads_max = try(each.value.linux_os_config.sysctl_config.kernel_threads_max, null)
          net_core_netdev_max_backlog = try(each.value.linux_os_config.sysctl_config.net_core_netdev_max_backlog, null)
          net_core_optmem_max = try(each.value.linux_os_config.sysctl_config.net_core_optmem_max, null)
          net_core_rmem_default = try(each.value.linux_os_config.sysctl_config.net_core_rmem_default, null)
          net_core_rmem_max = try(each.value.linux_os_config.sysctl_config.net_core_rmem_max, null)
          net_core_somaxconn = try(each.value.linux_os_config.sysctl_config.net_core_somaxconn, null)
          net_core_wmem_default = try(each.value.linux_os_config.sysctl_config.net_core_wmem_default, null)
          net_core_wmem_max = try(each.value.linux_os_config.sysctl_config.net_core_wmem_max, null)
          net_ipv4_ip_local_port_range_max = try(each.value.linux_os_config.sysctl_config.net_ipv4_ip_local_port_range_max, null)
          net_ipv4_ip_local_port_range_min = try(each.value.linux_os_config.sysctl_config.net_ipv4_ip_local_port_range_min, null)
          net_ipv4_neigh_default_gc_thresh1 = try(each.value.linux_os_config.sysctl_config.net_ipv4_neigh_default_gc_thresh1, null)
          net_ipv4_neigh_default_gc_thresh2 = try(each.value.linux_os_config.sysctl_config.net_ipv4_neigh_default_gc_thresh2, null)
          net_ipv4_neigh_default_gc_thresh3 = try(each.value.linux_os_config.sysctl_config.net_ipv4_neigh_default_gc_thresh3, null)
          net_ipv4_tcp_fin_timeout = try(each.value.linux_os_config.sysctl_config.net_ipv4_tcp_fin_timeout, null)
          net_ipv4_tcp_keepalive_intvl = try(each.value.linux_os_config.sysctl_config.net_ipv4_tcp_keepalive_intvl, null)
          net_ipv4_tcp_keepalive_probes = try(each.value.linux_os_config.sysctl_config.net_ipv4_tcp_keepalive_probes, null)
          net_ipv4_tcp_keepalive_time = try(each.value.linux_os_config.sysctl_config.net_ipv4_tcp_keepalive_time, null)
          net_ipv4_tcp_max_syn_backlog = try(each.value.linux_os_config.sysctl_config.net_ipv4_tcp_max_syn_backlog, null)
          net_ipv4_tcp_max_tw_buckets = try(each.value.linux_os_config.sysctl_config.net_ipv4_tcp_max_tw_buckets, null)
          net_ipv4_tcp_tw_reuse = try(each.value.linux_os_config.sysctl_config.net_ipv4_tcp_tw_reuse, null)
          net_netfilter_nf_conntrack_buckets = try(each.value.linux_os_config.sysctl_config.net_netfilter_nf_conntrack_buckets, null)
          net_netfilter_nf_conntrack_max = try(each.value.linux_os_config.sysctl_config.net_netfilter_nf_conntrack_max, null)
          vm_max_map_count = try(each.value.linux_os_config.sysctl_config.vm_max_map_count, null)
          vm_swappiness = try(each.value.linux_os_config.sysctl_config.vm_swappiness, null)
        }
      }
    }
  }

  dynamic "node_network_profile" {
    for_each = each.value.node_public_ip_tags == null ? [] : ["node_public_ip_tags"]
    content {
      node_public_ip_tags = each.value.node_public_ip_tags
    }
  }

  dynamic "upgrade_settings" {
    for_each = each.value.max_surge == null ? [] : ["upgrade_settings"]
    content {
      max_surge = each.value.max_surge
    }
  }
}