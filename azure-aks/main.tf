module "ssh-key" {
  source         = "./sshkey"
  public_ssh_key = var.public_ssh_key == "" ? "" : var.public_ssh_key
}

data "azurerm_client_config" "current" {}

# resource "azurerm_role_assignment" "aks" {
#   scope                = azurerm_kubernetes_cluster.aks-cluster.id
#   role_definition_name = "Monitoring Metrics Publisher"
#   principal_id         = azurerm_kubernetes_cluster.aks-cluster.addon_profile[0].oms_agent[0].oms_agent_identity[0].object_id
# }

resource "azurerm_role_assignment" "role-network_contributor" {
	scope								=  var.vnet_subnet_id
	role_definition_name				= "Network Contributor"
	principal_id						= azurerm_kubernetes_cluster.aks-cluster.identity[0].principal_id
	skip_service_principal_aad_check	= true	
}

# role assignment for AKS to pull images from ACR
resource "azurerm_role_assignment" "role-acr-pull" {
	scope                            = var.acr_id
	role_definition_name             = "AcrPull"
	principal_id                     = azurerm_kubernetes_cluster.aks-cluster.kubelet_identity[0].object_id
	skip_service_principal_aad_check = true
}


resource "azurerm_user_assigned_identity" "aks-identity" {
    resource_group_name = var.resource_group_name
    location            = var.location
    tags                = var.tags

    name = "msi-${var.cluster_name}"

    lifecycle {
        ignore_changes = [
        tags
        ]
    }
}


resource "azurerm_kubernetes_cluster" "aks-cluster" {
	name                             = var.cluster_name
	location                         = var.location
	resource_group_name              = var.resource_group_name
	kubernetes_version               = var.kubernetes_version
	dns_prefix                       = lower(var.dns_prefix)
	private_cluster_enabled          = var.private_cluster_enabled
	sku_tier                         = var.sku_tier
	node_resource_group              = "rg-${var.cluster_name}-worker"	
	azure_policy_enabled             = var.azure_policy_enabled
	http_application_routing_enabled = var.http_application_routing_enabled
	tags                             = var.tags

	default_node_pool {
		name                    = substr(var.default_node_pool.name, 0, 12)		
		orchestrator_version	= var.kubernetes_version
    	node_count              = var.default_node_pool.node_count		#2
		vm_size                 = var.default_node_pool.vm_size  		#Standard_D2_v2
		os_disk_size_gb         = var.default_node_pool.os_disk_size_gb
		vnet_subnet_id          = var.vnet_subnet_id
		type					= "VirtualMachineScaleSets"
		
		pod_subnet_id           = var.pod_subnet_id != null ? var.pod_subnet_id : null
		zones					= var.default_node_pool.zones
		enable_auto_scaling   	= var.default_node_pool.cluster_auto_scaling
		max_count               = var.default_node_pool.cluster_auto_scaling == true ? var.default_node_pool.cluster_auto_scaling_max_count : null	#4
    	min_count               = var.default_node_pool.cluster_auto_scaling == true ? var.default_node_pool.cluster_auto_scaling_min_count : null	#2
		max_pods                = var.default_node_pool.max_pods   #250
	  	os_disk_type            = var.default_node_pool.os_disk_type
    	tags                    = var.tags
		
    }

    dynamic "maintenance_window_node_os" {
		for_each = var.maintenance_window_node_os != null ? [1] : []
		content {
			frequency   = var.maintenance_window_node_os.frequency
			interval    = var.maintenance_window_node_os.interval
			duration    = var.maintenance_window_node_os.duration
			day_of_week = var.maintenance_window_node_os.day_of_week
			start_time  = var.maintenance_window_node_os.start_time
		}
	}

    dynamic "linux_profile" {
		for_each = var.linux_profile != null ? [true] : []
		content {
			admin_username = var.linux_profile.username
			ssh_key {
				key_data = replace(var.public_ssh_key == "" ? module.ssh-key.public_ssh_key : var.public_ssh_key, "\n", "")
			}
		}
	}

	dynamic "windows_profile" {
		for_each = var.windows_profile != null ? [true] : []
		content {
			admin_username = var.windows_profile.username
			admin_password = var.windows_profile.password
		}
	}


    identity {
		type         = var.identity_type
		identity_ids = var.identity_type == "UserAssigned" ? [azurerm_user_assigned_identity.aks-identity.id] : null
	}

 	network_profile {
		network_plugin     = var.network_plugin
		network_policy     = var.network_plugin == "kubenet" ? null : var.network_policy
		pod_cidr           = var.network_policy == "kubenet" ? var.pod_cidr : null
		#docker_bridge_cidr = var.docker_bridge_cidr
		dns_service_ip     = cidrhost(var.service_cidr, 10)
		service_cidr       = var.service_cidr # data.azurerm_subnet.services.address_prefixes[0]
		
		# Use Standard if availability zones are set, Basic otherwise
		load_balancer_sku = var.load_balancer_sku  #"standard"
		outbound_type     = var.outbound_type
	}

  	dynamic "ingress_application_gateway" {
		for_each = try(var.ingress_application_gateway.gateway_id, null) == null ? [] : [1]
			content {
				gateway_id      = var.ingress_application_gateway.gateway_id
				subnet_cidr     = var.ingress_application_gateway.subnet_cidr
				subnet_id       = var.ingress_application_gateway.subnet_id				
			}
	}

	dynamic "oms_agent" {
		for_each = var.oms_agent.log_analytics_workspace_id != null ? [true] : []
		content {
			log_analytics_workspace_id =  coalesce(var.oms_agent.log_analytics_workspace_id, var.log_analytics_workspace_id)
			msi_auth_for_monitoring_enabled = true
		}
	}
	azure_active_directory_role_based_access_control {
		managed 				= var.azure_rbac_enabled
		azure_rbac_enabled     	= var.azure_rbac_enabled
		admin_group_object_ids 	= var.azure_rbac_enabled == true ? var.cluster_admin_ids : []
		tenant_id              	= var.azure_rbac_enabled == true ? data.azurerm_client_config.current.tenant_id : null

	}

  	workload_autoscaler_profile {
		keda_enabled                    = var.keda_enabled
		vertical_pod_autoscaler_enabled = var.vertical_pod_autoscaler_enabled
    }
  	lifecycle {
		# Prevents the AKS cluster from being deleted if the node count is set to 0
		prevent_destroy = true
    	ignore_changes = [
			kubernetes_version,
			tags
		]
    }
}


resource "azurerm_kubernetes_cluster_node_pool" "aks-cluster" {
	for_each = var.additional_node_pools
		kubernetes_cluster_id = azurerm_kubernetes_cluster.aks-cluster.id
		name                  = each.value.node_os == "Windows" ? substr(each.key, 0, 6) : substr(each.key, 0, 12)
		node_count            = each.value.node_count
		vm_size               = each.value.vm_size
		zones                 = each.value.zones
		mode 				  = each.value.mode             # System or User
		max_pods              = each.value.max_pods			#250
		os_disk_size_gb       = each.value.os_disk_size_gb  #128
		
		os_type               = each.value.node_os
		vnet_subnet_id        = var.vnet_subnet_id
		node_taints           = each.value.taints		
		
		enable_auto_scaling   = each.value.cluster_auto_scaling
		max_count             = each.value.cluster_auto_scaling == true ? each.value.cluster_auto_scaling_max_count : null	#4
    	min_count             = each.value.cluster_auto_scaling == true ? each.value.cluster_auto_scaling_min_count : null	#2
		tags                  = var.tags
		 
	lifecycle {
    	ignore_changes = [
      		node_count
    	]
    }
}
