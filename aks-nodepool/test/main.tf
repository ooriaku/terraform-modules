data "azurerm_resource_group" "testrg" {
  name = "rg-fs-tf-modules-test"
}

resource "random_string" "random" {
  length  = 5
  special = false
}

module "monitor" {
  source              = "../../monitor"
  la_name             = "${local.name}-la-${lower(random_string.random.result)}"
  app_insights_name   = "${local.name}-appi-${lower(random_string.random.result)}"
  location            = data.azurerm_resource_group.testrg.location
  resource_group_name = data.azurerm_resource_group.testrg.name
  tags                = local.tags
}

module "ci_solution" {
  source                = "../../log-analytics-solution"
  solution_name         = "ContainerInsights"
  resource_group_name   = data.azurerm_resource_group.testrg.name
  location              = data.azurerm_resource_group.testrg.location
  workspace_resource_id = module.monitor.workspace_resource_id
  workspace_name        = module.monitor.workspace_name
  publisher             = "Microsoft"
  product               = "OMSGallery/ContainerInsights"
  
  tags = local.tags
}

module "logs_sa" {
  source              = "../../storageaccount"
  name                = "${local.name_no_dash}logs${lower(random_string.random.result)}"
  location            = data.azurerm_resource_group.testrg.location
  resource_group_name = data.azurerm_resource_group.testrg.name
  replication_type    = "LRS"

  tags = local.tags
}

module "vnet" {
  source              = "../../vnet"
  vnet_name           = "aks_vnet"
  resource_group_name = data.azurerm_resource_group.testrg.name
  address_space       = ["10.40.0.0/16"]
  subnet_prefixes     = ["10.40.0.0/22", "10.40.4.0/25", "10.40.4.128/25"]
  subnet_names        = ["aks_subnet", "ingress_subnet", "GatewaySubnet"]
  location            = data.azurerm_resource_group.testrg.location

  # subnet_service_endpoints = {
  #   aks_subnet = ["Microsoft.ContainerRegistry", "Microsoft.Sql", "Microsoft.KeyVault"]
  # }

  subnet_enforce_private_link_endpoint_network_policies = {
    "aks_subnet" = true
  }

  tags = local.tags
}

module "logging_vnet" {
  source         = "../../logging"
  basename       = "vnet"
  resource_id    = module.vnet.vnet_id
  sa_id          = module.logs_sa.id
  la_id          = module.monitor.workspace_resource_id
  retention_days = 180
  logs           = ["VMProtectionAlerts"]
  metrics        = ["AllMetrics"]
}

module "aks" {
  source                          = "../../aks"
  prefix                          = "aks-cluster"
  resource_group_name             = data.azurerm_resource_group.testrg.name
  client_id                       = "" #var.client_id
  client_secret                   = "" #var.client_secret
  network_plugin                  = "azure"
  vnet_subnet_id                  = module.vnet.subnet_ids[0]
  os_disk_size_gb                 = 60
  enable_http_application_routing = true
  enable_azure_policy             = true
  enable_host_encryption          = true
  sku_tier                        = "Paid"
  private_cluster_enabled         = false
  enable_auto_scaling             = false
  agents_count                    = 1
  agents_max_pods                 = 30
  agents_availability_zones       = ["1", "2"]
  agents_type                     = "VirtualMachineScaleSets"
  location                        = data.azurerm_resource_group.testrg.location
  enable_log_analytics_workspace  = true
  log_analytics_workspace_id      = module.monitor.workspace_resource_id

  agents_labels = {
    "nodepool" : "defaultnodepool"
  }

  agents_tags = {
    "Agent" : "defaultnodepoolagent"
  }
  network_policy                 = "azure"
  net_profile_dns_service_ip     = "10.0.0.10"
  net_profile_service_cidr       = "10.0.0.0/16"

  depends_on = [data.azurerm_resource_group.testrg, module.vnet]
}

module "logging_aks" {
  source         = "../../logging"
  basename       = "aks"
  resource_id    = module.aks.aks_id
  sa_id          = module.logs_sa.id
  la_id          = module.monitor.workspace_resource_id
  retention_days = 180
  logs           = ["kube-apiserver", "kube-audit", "kube-audit-admin", "kube-controller-manager", "kube-scheduler", "cluster-autoscaler", "guard"]
  metrics        = ["AllMetrics"]
}

module "nodepools" {
  source                = "../"
  kubernetes_cluster_id = module.aks.aks_id
  vnet_subnet_id        = module.vnet.subnet_ids[0]
  node_pools = [
    {
      name       = "pool1"
      priority   = "Regular"
      os_type    = "Windows"
      vm_size    = "Standard_B4ms"
      node_count = 1
      tags       = local.tags
    },
    {
      name       = "userpool2"
      priority   = "Regular"
      os_type    = "Linux"
      vm_size    = "Standard_D2s_v3"
      node_count = 1
      tags       = local.tags
      kubelet_config = {
        container_log_max_size_mb = "5"
      }
      linux_os_config = {
        swap_file_size_mb = "1000"
        sysctl_config ={
          fs_aio_max_nr = 655360
        }
      }
    }
  ]
}