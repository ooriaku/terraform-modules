# Azure AKS nodepool Module


## Summary

Azure AKS Module which creates AKS Cluster nodepools and attaches those to an existing cluster.

## Inputs

| Variable Name                  | Type   | Default | Description |
|--------------------------------|--------|---------|-------------|
| kubernetes_cluster_id          | string |         | The ID of the Kubernetes Cluster where this Node Pool should exist. Changing this forces a new resource to be created. The type of Default Node Pool for the Kubernetes Cluster must be VirtualMachineScaleSets to attach multiple node pools. |
| vnet_subnet_id                 | string | null    | The ID of the Subnet where this Node Pool should exist. At this time the vnet_subnet_id must be the same for all node pools in the cluster. |
| pod_subnet_id                  | string | null    | The ID of the Subnet where the pods in the Node Pool should exist. Changing this forces a new resource to be created. |
| capacity_reservation_group_id  | string | null    | The ID of capacity reservation group. Recreates the nodepool. |
| kubelet_disk_type              | string | null    | The type of disk used by kubelet. Possible values are `OS` and `Temporary`. |
| host_group_id                  | string | null    | The ID of host group. Recreates the nodepool. |
| proximity_placement_group_id   | string | null    | The ID of the Proximity Placement Group where the Virtual Machine Scale Set that powers this Node Pool will be placed. Changing this forces a new resource to be created. |
| vm_size                        | string | Standard_D2s_v3 | The SKU which should be used for the Virtual Machines used in this Node Pool. Changing this forces a new resource to be created. |
| availability_zones             | list   | null    | A list of Availability Zones across which the Node Pool should be spread. Changing this forces a new resource to be created. This requires that the type is set to VirtualMachineScaleSets and that load_balancer_sku is set to Standard. |
| enable_auto_scaling            | bool   | false   | Should the Kubernetes Auto Scaler be enabled for this Node Pool? This requires that the type is set to VirtualMachineScaleSets. |
| enable_host_encryption         | bool   | false   | Should the nodes in the Default Node Pool have host encryption enabled? |
| enable_node_public_ip          | bool   | false   | Should nodes in this Node Pool have a Public IP Address? |
| node_public_ip_prefix_id       | string | null    | Resource ID for the Public IP Addresses Prefix for the nodes in this Node Pool. enable_node_public_ip should be true. Changing this forces a new resource to be created. |
| eviction_policy                | string | Delete  | The Eviction Policy which should be used for Virtual Machines within the Virtual Machine Scale Set powering this Node Pool. Possible values are Deallocate and Delete. Changing this forces a new resource to be created. |
| max_pods                       | number | null    | The maximum number of pods that can run on each agent. Changing this forces a new resource to be created. |
| mode                           | string | User    | Should this Node Pool be used for System or User resources? Possible values are System and User. |
| node_labels                    | map    | {}      | A map of Kubernetes labels which should be applied to nodes in the Default Node Pool. Changing this forces a new resource to be created. |
| node_taints                    | list   | null    | A list of Kubernetes taints which should be applied to nodes in the agent pool (e.g key=value:NoSchedule). Changing this forces a new resource to be created. |
| orchestrator_version           | string | null    | Version of Kubernetes |
|-----------------------|------------------|---------|-------------------------------------------------------------------------------------------------------------------------------------|
| os_disk_size_gb        | number           | null    | The size of the OS Disk which should be used for each agent in the Node Pool. Changing this forces a new resource to be created.    |
| os_disk_type           | string           | Managed | The type of disk which should be used for the Operating System. Possible values are Ephemeral and Managed. Changing this forces a new resource to be created. |
| os_type                | string           | Linux   | The Operating System which should be used for this Node Pool. Changing this forces a new resource to be created. Possible values are Linux and Windows. |
| priority               | string           | Regular | The Priority for Virtual Machines within the Virtual Machine Scale Set that powers this Node Pool. Possible values are Regular and Spot. Changing this forces a new resource to be created. |
| spot_max_price         | number           | null    | The maximum price you're willing to pay in USD per Virtual Machine. Valid values are -1 (the current on-demand price for a Virtual Machine) or a positive value with up to five decimal places. Changing this forces a new resource to be created. |
| tags                   | map(string)      | {}      | A mapping of tags which should be assigned to Resource.                                                                               |
| max_count              | number           | null    | The maximum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000.                       |
| min_count              | number           | null    | The minimum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000.                       |
| node_count             | number           | 0       | The initial number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000 and between min_count and max_count. |
| max_surge              | string           | null    | The maximum number or percentage of nodes which will be added to the Node Pool size during an upgrade. If a percentage is provided, the number of surge nodes is calculated from the node_count value on the current cluster. Node surge can allow a cluster to have more nodes than max_count during an upgrade. |
| node_public_ip_tags    | list(string)     | null    | Specifies a mapping of tags to the instance-level public IPs. Changing this forces a new resource to be created. Preview feature  |
| kubelet_config         | map(string)      | null    | Kubelet config object. Valid options are: allowed_unsafe_sysctls, container_log_max_line, container_log_max_size_mb, cpu_cfs_quota_enabled, cpu_cfs_quota_period, cpu_manager_policy, image_gc_high_threshold, image_gc_low_threshold, pod_max_pid, topology_manager_policy. |
| linux_os_config        | map(string)      | null    | Linux OS configuration options. Valid options are: swap_file_size_mb, sysctl_config, transparent_huge_page_defrag, transparent_huge_page_enabled. |
| scale_down_mode        | string           | null    | Specifies how the node pool should deal with scaled-down nodes. Allowed values are Delete and Deallocate. Defaults to Delete. |
| ultra_ssd_enabled      | bool             | null    | Used to specify whether the UltraSSD is enabled in the Node Pool. Defaults to false. Changing this forces a new resource to be created. |
| workload_runtime       | string           | null    | Used to specify the workload runtime. Allowed values are OCIContainer and WasmWasi. At the time of writting this was a Preview feature |
| windows_profile | map(string)    | null    | Used to specify the Windows OS node configuration. Currently supported values is: *outbound_nat_enabled |
| node_pools      | any            | []      | Allows to create multiple Node Pools. node_pools can have more than one pool. The name attribute is used to create key/value map, and priority is needed to filter, but all the other elements are optional. Name for Linux pool maximum of 12 characters and for Windows pools maximum of 6. Valid fields are: * name * capacity_reservation_group_id * host_group_id * vm_size * kubelet_config * availability_zones * enable_auto_scaling * enable_host_encryption * enable_node_public_ip * eviction_policy * max_pods * mode * node_labels * node_taints * orchestrator_version * os_disk_size_gb * os_disk_type * os_type * priority * spot_max_price * tags * max_count * min_count * node_count * max_surge. These vaules will overwirite the defaults (set as variables) per particular nodepool|

## Outputs

| Variable Name           | Type | Default | Description                                         |
|-------------------------|------|---------|-----------------------------------------------------|
| spot_node_pools_ids     | array(string)  | n/a     | Spot priority Node Pools IDs.             |
| regular_node_pools_ids  | array(string)  | n/a     | Regular priority Node Pools IDs.          |
| node_pools              | any  | []      | The actual 'node_pools' input used for      testing |

## Known issues