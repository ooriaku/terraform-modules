# Azure AKS Module


## Summary

Azure AKS Module which creates AKS Cluster 

## Inputs


| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `location` | location of resources | `string` | `none` | yes |
| `resource_group_name` | The Name of the resource grop to which the resources will be deployed  | `string` | `none` | yes |
| `cluster_name` | The name for the AKS resources created in the specified Azure Resource Group | `string` | `null` | yes |
| `log_analytics_workspace_id` | ID of the log analytics workspace to send logs to | `string` | `null` | yes |
| `enable_log_analytics_workspace` | Enable logging to log analytics workspace.Defaults to false | `bool` | `false` | yes |
| `prefix` | The prefix for the resources created in the specified Azure Resource Group| `string` | `none` | yes |
| `client_id` | The Client ID (appId) for the Service Principal used for the AKS deployment | `string` | `null` | yes |
| `client_secret` | The Client Secret (password) for the Service Principal used for the AKS deployment | `string` | `null` | yes |
| `admin_username` | The username of the local administrator to be created on the Kubernetes cluster | `string` | `null` | yes |
| `agents_size` | The default virtual machine size for the Kubernetes agents | `string` | `Standard_D2s_v3` | yes |
| `agents_count` | The number of Agents that should exist in the Agent Pool. Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes. | `number` | `1` | yes |
| `public_ssh_key` | A custom ssh key to control access to the AKS cluster | `string` | `null` | yes |
| `tags` | Any tags that should be present on the Virtual Network resources | `map(string)` | `null` | yes |
| `vnet_subnet_id` | The ID of a Subnet where the Kubernetes Node Pool should exist. Changing this forces a new resource to be created | `string` | `null` | yes |
| `os_disk_size_gb` | The Disk size of AKS nodes in GBs | `number` | `50` | yes |
| `private_cluster_enabled` | If true cluster API server will be exposed only on internal IP address and available only in cluster vnet | `bool` | `false` | yes |
| `api_server_authorized_ip_ranges` | we have to Specify authorized IPs for access to AKS API | `set(string)` | `null` | yes |
| `disk_encryption_set_id` | Disk encryption set to be used for CMK encryption of AKS disks| `string` | `null` | yes |
| `enable_http_application_routing` | To Enable HTTP Application Routing Addon and it (forces recreation). | `bool` | `false` | yes |
| `enable_azure_policy` | This will Enable the Kubernetes Policy. | `bool` | `false` | yes |
| `sku_tier` | The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid | `string` | `Free` | yes |
| `enable_role_based_access_control` | This will Enable Role Based Access Control for AKS cluster and the resources to be accessed  | `bool` | `false` | yes |
| `rbac_aad_managed` | If the Azure Active Directory integration Managed, meaning that Azure will create/manage the Service Principal used for integration. | `bool` | `false` | yes |
| `rbac_aad_admin_group_object_ids` | This is the Object ID of groups with admin access | `list(string)` | `null` | yes |
| `rbac_aad_client_app_id` | This is the Client ID of an Azure Active Directory Application. | `string` | `null` | yes |
| `rbac_aad_server_app_id` | The Server ID of an Azure Active Directory Application. | `string` | `null` | yes |
| `rbac_aad_server_app_secret` | This is used for the Server Secret of an Azure Active Directory Application | `bool` | `false` | yes |
| `network_plugin` | Network plugin is used to assign IP's to the Kubernetes objects| `string` | `kubenet` | yes |
| `network_policy` | Sets up network policy to be used with Azure CNI. Network policy allows us to control the traffic flow between pods. Currently supported values are calico and azure. Changing this forces a new resource to be created | `string` | `null` | optional |
| `net_profile_dns_service_ip` | IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Changing this forces a new resource to be created. | `string` | `null` | optional |
| `net_profile_outbound_type` | The outbound (egress) routing method which should be used for this Kubernetes Cluster. Possible values are loadBalancer and userDefinedRouting. Defaults to loadBalancer| `string` | `loadBalancer` | optional |
| `net_profile_pod_cidr` | The CIDR to use for pod IP addresses. This field can only be set when network_plugin is set to kubenet. Changing this forces a new resource to be created | `string` | `null` | optional |
| `net_profile_service_cidr` | The Network Range used by the Kubernetes service. Changing this forces a new resource to be created. | `string` | `null` | optional |
| `kubernetes_version` | Specify which Kubernetes release to use. The default used is the latest Kubernetes version available in the region | `string` | `null` | yes |
| `orchestrator_version` | Specify which Kubernetes release to use for the orchestration layer. The default used is the latest Kubernetes version available in the region| `string` | `null` | yes |
| `enable_auto_scaling` | This will enable node pool autoscaling for the AKS Cluster| `bool` | `false` | yes |
| `agents_max_count` | This will enable maximum number of agents in the pool of the cluster. | `number` | `null` | yes |
| `agents_min_count` | This will enable minimum number of agents in the pool of the cluster. | `number` | `null` | yes |
| `agents_pool_name` | The default Azure AKS agentpool name is (nodepool) | `string` | `nodepool` | yes |
| `enable_node_public_ip` | Should the nodes in this Node Pool have a Public IP Address? Defaults to false| `bool` | `false` | optional |
| `agents_availability_zones` | A list of Availability Zones across which the Node Pool should be spread. Changing this forces a new resource to be created | `list(string)` | `null` | optional |
| `agents_labels` | A map of Kubernetes labels which should be applied to nodes in the Default Node Pool. Changing this forces a new resource to be created | `map(string)` | `empty` | optional |
| `agents_type` | The type of Node Pool which should be created. Possible values are AvailabilitySet and VirtualMachineScaleSets. Defaults to VirtualMachineScaleSets Changing this forces a new resource to be created | `VirtualMachineScaleSets` | `string` | optional |
| `agents_tags` | A map of Kubernetes labels which should be applied to nodes in the Default Node Pool. Changing this forces a new resource to be created | `map(string)` | `empty` | optional |
| `agents_max_pods` | A map of Kubernetes labels which should be applied to nodes in the Default Node Pool. Changing this forces a new resource to be created | `map(string)` | `empty` | optional |
| `identity_type` | A map of Kubernetes labels which should be applied to nodes in the Default Node Pool. Changing this forces a new resource to be created | `map(string)` | `empty` | optional |
| `user_assigned_identity_id` | A map of Kubernetes labels which should be applied to nodes in the Default Node Pool. Changing this forces a new resource to be created | `list(string)` | `empty` | optional |
| `enable_host_encryption` | A map of Kubernetes labels which should be applied to nodes in the Default Node Pool. Changing this forces a new resource to be created | `map(string)` | `empty` | optional |
| `enable_osm` | A map of Kubernetes labels which should be applied to nodes in the Default Node Pool. Changing this forces a new resource to be created | `map(string)` | `empty` | optional |
| `enable_app_gw` | Whether to enable app gateway integration | `bool` | `false` | optional |
| `gateway_id` | ID of Gateway to use | `string` | `null` | optional |
| `gateway_name` | The name of the Application Gateway to be used or created in the Nodepool Resource Group | `string` | `null` | optional |
| `appgw_subnet_cidr` | The subnet CIDR to be used to create an Application Gateway | `string` | `null` | optional |
| `appgw_subnet_id` | The ID of the subnet on which to create an Application Gateway | `string` | `null` | optional |
| `enable_kv_csi` | Whether to enable Key Vault integration | `bool` | `false` | optional |

### OUTPUTS

| Name | Description |
|------|-------------|
| `client_key` | client key of the azurerm_kubernetes_cluster | 
| `client_certificate` | client certificate of the azure kubernetes cluster| 
| `cluster_ca_certificate` | certificate authority of the AKS cluster  | 
| `host` | Hostname of the AKS cluster  | 
| `username` | username of the AKS cluster and  | 
| `password` | password of azurerm_kubernetes_cluster | 
| `node_resource_group` | outputs the value of node_resource_group in the AKS cluster  | 
| `location` | location of the AKS cluster and the resources deployed| 
| `aks_id` | ID of the AKS cluster | 
| `kube_config_raw` | outputs the details of the kube config file | 
| `http_application_routing_zone_name` | Displays the application routing zone name for the http protocol | 
| `system_assigned_identity` | Created as part of an Azure resource (for example, an Azure virtual machine or Azure App Service) | 
| `kubelet_identity` | Displays the identity of the kubelet in AKS cluster   | 
| `admin_client_key` | output's the admin client of the AKS cluster | 
| `admin_client_certificate` | Display's admin client certifcate of the azurerm_kubernetes_cluster | 
| `admin_cluster_ca_certificate` | ca certificate  of the azurerm_kubernetes_cluster | 
| `admin_host` | hostname of the  azurerm_kubernetes_cluster | 
| `admin_username` | Display's admin username of the  azurerm_kubernetes_cluster | 
| `admin_password` | output's the admin password for  azurerm_kubernetes_cluster | 
| `appgw_identity_id` | App GW Identity - principle id. |
| `kv_csi_identity_id` | Key Vault CSI Identity - principle id. |
| `kv_csi_identity_uaid` | Key Vault CSI Identity - user assigned ID |




### KNOWN ISSUES

1. Encryption at host

    Enable encryption at host by running:
    ```bash
    az feature register --namespace "Microsoft.Compute" --name "EncryptionAtHost"
    ```
    or when you call the module, supply the following value:
    ```hcl
    enable_host_encryption = false
    ```
1. Container Insights

    If oms_agent is enabled for a particular AKS CLuster, it shall deploy `ContainerInsights` solution to the Log Analytics (LA) Workspace. Since the LA is handled outside of Terraform, resource group destroy might fail. To address this, deploy `ContainerInsights` solution with Terraform. 