variable "cluster_name" {
	description = "(Required) Specifies the name of the AKS cluster."
	type        = string
}

variable "resource_group_name" {
	description = "(Required) Specifies the name of the resource group."
	type        = string
}

variable "resource_group_id" {
	description = "(Required) Specifies the resource id of the resource group."
	type        = string
}

variable "location" {
	description = "(Required) Specifies the location where the AKS cluster will be deployed."
	type        = string
}

variable "acr_id" {
	description = ""
	type	= string
}

variable "dns_prefix" {
	description = "(Optional) DNS prefix specified when creating the managed cluster. Changing this forces a new resource to be created."
	type        = string
	default = ""
}

variable "linux_profile" {
	type = object({
		username = string
		ssh_key	 = string
	})
	default = null
}

variable "windows_profile" {
	type = object({
		username = string
		password = string
	})
	sensitive	= true
	default		= null
}

variable "private_cluster_enabled" {
	description = "Should this Kubernetes Cluster have its API server only exposed on internal IP addresses? This provides a Private IP Address for the Kubernetes API on the Virtual Network where the Kubernetes Cluster is located. Defaults to false. Changing this forces a new resource to be created."
	type        = bool
	default     = false
}

variable "azure_rbac_enabled" {
	description = "(Optional) Is Role Based Access Control based on Microsoft Entra ID enabled?"
	default     = true
	type        = bool
}

variable "automatic_channel_upgrade" {
  description = "(Optional) The upgrade channel for this Kubernetes Cluster. Possible values are patch, rapid, and stable."
  default     = "stable"
  type        = string

  validation {
    condition = contains( ["patch", "rapid", "stable"], var.automatic_channel_upgrade)
    error_message = "The upgrade mode is invalid."
  }
}

variable "log_analytics_workspace_id" {
  description = "(Optional) The ID of the Log Analytics Workspace to use for monitoring this AKS Cluster."
  type        = string
  default     = null
  
}

variable "service_cidr" {
	type	= string
	default = null	
}

variable "vnet_subnet_id" {
	type	= string
	default = null
}

variable "pod_subnet_id" {
  type	= string
  default = null  
}

variable "pod_cidr" {
	type	= string
	default = null
}

variable "sku_tier" {
	description = "(Optional) The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid (which includes the Uptime SLA). Defaults to Free."
	default     = "Free"
	type        = string

	validation {
		condition = contains( ["Free", "Standard", "Premium"], var.sku_tier)
		error_message = "The sku tier is invalid."
	}
}

variable "cluster_admin_ids" {
  description = "(Optional) A list of Object IDs of Microsoft Entra ID Users which should have Admin Role on the Cluster."
  default     = ["6e5de8c1-5a4b-409b-994f-0706e4403b77", "78761057-c58c-44b7-aaa7-ce1639c6c4f5"]
  type        = list(string)  
}
variable "kubernetes_version" {
	type = string
	default = "1.32.4"
}

variable "azure_policy_enabled" {
  description = "(Optional) Should Azure Policy be enabled for this Kubernetes Cluster? Defaults to false."
  type        = bool
  default     = false
}

variable "identity_type" {
	type	= string
	default = "SystemAssigned"
	validation {
		condition = contains( ["SystemAssigned", "UserAssigned"], var.identity_type)
		error_message = "The identity type is invalid."
	}
}

variable "http_application_routing_enabled" {
  description = "(Optional) Should HTTP Application Routing be enabled for this Kubernetes Cluster? Defaults to false."
  type        = bool
  default     = false
  
}
variable "prevent_destroy" {
	description = "(Optional) Prevents the resource from being destroyed. Defaults to false."
	type        = bool
	default     = false  
}

variable "network_policy" {
	type	= string
	default = "azure"
	validation {
		condition = contains( ["calico", "azure"], var.network_policy)
		error_message = "The network policy is invalid."
	}
}


variable "network_plugin" {
	type	= string
	default = "azure"
	validation {
		condition = contains( ["kubenet", "azure"], var.network_plugin)
		error_message = "The network plugin is invalid."
	}
}

variable "ingress_application_gateway" {
	description = "Specifies the Application Gateway Ingress Controller addon configuration."
	type        = object({		
		gateway_id   = optional(string)
		gateway_name = optional(string)
		subnet_cidr  = optional(string)
		subnet_id    = optional(string)
	})
	default     = {		         
		gateway_id   = null
		gateway_name = null
		subnet_cidr  = null
		subnet_id    = null
	}
}

variable "key_vault_secrets_provider" {
	type = object({
		enabled					= bool
		secret_rotation_enabled = bool
		secret_rotation_interval= string
	})
	default = {
		enabled                  = false
		secret_rotation_enabled  = false
		secret_rotation_interval = "2m"
	}
}

variable "maintenance_window_node_os" {
	type = object({
		frequency = string
		interval  = number
		duration  = number
		day_of_week = string
		start_time	= string
	})
	default = null
}

variable "docker_bridge_cidr" {
	type	= string
	default = "172.17.0.1/16"
}


variable "default_node_pool" {
	description = "The object to configure the default node pool with number of worker nodes, worker node VM size and Availability Zones."
	type = object({
		name                           	= string
		node_count                     	= number
		vm_size                        	= string
		zones                          	= list(string)
		taints                         	= list(string)
		cluster_auto_scaling           	= bool
		cluster_auto_scaling_min_count 	= number
		cluster_auto_scaling_max_count 	= number
		max_pods						= number
		os_disk_size_gb                	= number
		os_disk_type                   	= string
		enable_auto_scaling				= optional(bool, false)
  })
}

variable "public_ssh_key" {
	description = "(Optional) The public SSH key to use for the cluster. If not provided, a new SSH key will be generated."
	type        = string
	default     = ""  
}

variable "additional_node_pools" {
  type = map(object({
    node_count                     = number
    vm_size                        = string
    zones                          = list(string)
    node_os                        = string
    taints                         = list(string)	
	os_disk_size_gb				   = number
	mode						   = string
	max_pods                       = number	
	cluster_auto_scaling 		   = optional(bool, false)
    cluster_auto_scaling_min_count = number
    cluster_auto_scaling_max_count = number
  }))
}

variable "outbound_type" {
	description = "(Optional) The outbound (egress) routing method which should be used for this Kubernetes Cluster. Possible values are loadBalancer and userDefinedRouting. Defaults to loadBalancer."
	type        = string
	default     = "loadBalancer"

	validation {
		condition = contains(["loadBalancer",  "managedNATGateway", "userAssignedNATGateway", "userDefinedRouting"], var.outbound_type)
		error_message = "The outbound type is invalid."
	}
}

variable "load_balancer_sku" {
	description = "(Optional) Specifies the SKU of the Load Balancer used for this Kubernetes Cluster. Possible values are basic and standard. Defaults to basic."
	type        = string
	default     = "basic"

	validation {
		condition = contains(["basic",  "standard"], var.load_balancer_sku)
		error_message = "The load balancer sku is invalid."
	}
}

variable "keda_enabled" {
	type	= bool
	default = false
}

variable "vertical_pod_autoscaler_enabled" {
	type	= bool
	default = false
}

variable "tags" {
  description = ""
  type        = map(any)
  default     = {}
}

variable "oms_agent" {
  description = "Specifies the OMS agent addon configuration."
  type        = object({
    enabled                     = bool           
    log_analytics_workspace_id  = string
  })
  default     = {
    enabled                     = true
    log_analytics_workspace_id  = null
  }
}



