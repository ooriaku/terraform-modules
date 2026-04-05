#---------------------------------
# Local declarations
#---------------------------------
locals { 
  resource_prefix  = var.resource_prefix == "" ? var.resource_group_name : var.resource_prefix
  virtual_machines = { 
    for idx, vm in var.backup_virtual_machines : vm.name => {
       idx : idx,
       vm : vm,
    }
  }

  file_shares = {
    for idx, fs in var.backup_file_shares : fs.name => {
      idx : idx
      file_share : fs
    }
  }

  timeout_create  = "180m"
  timeout_delete  = "60m"
  timeout_read    = "60m"
}

#-------------------------------------
## Recovery Services
#-------------------------------------

resource "azurerm_recovery_services_vault" "vault" {
  name                = var.recovery_services_vault_name != "" ? var.recovery_services_vault_name : "${local.resource_prefix}-bvault"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.recovery_services_vault_sku != null ? var.recovery_services_vault_sku : "Standard"
  storage_mode_type   = var.recovery_services_vault_storage_mode != null ? var.recovery_services_vault_storage_mode : "LocallyRedundant"
  
  #cross_region_restore_enabled = var.recovery_servuces_vault_cross_region_restore_enabled

  tags     = merge({ "ResourceName" = var.recovery_services_vault_name != "" ? var.recovery_services_vault_name : "${local.resource_prefix}-bvault" }, var.tags, )

  timeouts {
    create  = local.timeout_create
    delete  = local.timeout_delete
    read    = local.timeout_read
  }  
}

#-------------------------------------
## Backup Policy
#-------------------------------------

resource "azurerm_backup_policy_vm" "policy" {
  name                = "${local.resource_prefix}-bkpol-vms"
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name
  policy_type         = var.backup_policy_type != null ? var.backup_policy_type : "V2"

  timezone = var.backup_policy_time_zone != null ? var.backup_policy_time_zone : "UTC"

  backup {
    frequency = var.backup_policy_frequency != null ? var.backup_policy_frequency : "Daily"
    time      = var.backup_policy_time != null ? var.backup_policy_time : "23:00"
  }

  dynamic "retention_daily" {
    for_each = var.backup_policy_retention_daily_count != "" ? [1] : []

    content {
      count = var.backup_policy_retention_daily_count
    }
  }

  dynamic "retention_weekly" {
    for_each = var.backup_polcy_retention_weekly_count != "" ? [1] : []

    content {
      count = var.backup_polcy_retention_weekly_count
      weekdays = var.backup_policy_retention_weekly_weekdays != null ? var.backup_policy_retention_weekly_weekdays : [ "Saturday" ]
    }
  }

  dynamic "retention_monthly" {
    for_each = var.backup_polcy_retention_monthly_count != "" ? [1] : []

    content {
      count = var.backup_polcy_retention_monthly_count
      weekdays  = var.backup_policy_retention_monthly_weekdays != null ? var.backup_policy_retention_monthly_weekdays : [ "Saturday" ]
      weeks     = [ "Last" ]
    }
  }  

  timeouts {
    create  = local.timeout_create
    delete  = local.timeout_delete
    read    = local.timeout_read
  }
}

resource "azurerm_backup_policy_file_share" "policy" {
  name                = "${local.resource_prefix}-bkpol-fileshares"
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name

  timezone = var.backup_policy_time_zone != null ? var.backup_policy_time_zone : "UTC"

  backup {
    frequency = var.backup_policy_frequency != null ? var.backup_policy_frequency : "Daily"
    time      = var.backup_policy_time != null ? var.backup_policy_time : "23:00"
  }

  dynamic "retention_daily" {
    for_each = var.backup_policy_retention_daily_count != "" ? [1] : []

    content {
      count = var.backup_policy_retention_daily_count
    }
  }

  dynamic "retention_weekly" {
    for_each = var.backup_polcy_retention_weekly_count != "" ? [1] : []

    content {
      count = var.backup_polcy_retention_weekly_count
      weekdays = var.backup_policy_retention_weekly_weekdays != null ? var.backup_policy_retention_weekly_weekdays : [ "Saturday" ]
    }
  }

  dynamic "retention_monthly" {
    for_each = var.backup_polcy_retention_monthly_count != "" ? [1] : []

    content {
      count = var.backup_polcy_retention_monthly_count
      weekdays  = var.backup_policy_retention_monthly_weekdays != null ? var.backup_policy_retention_monthly_weekdays : [ "Saturday" ]
      weeks     = [ "Last" ]
    }
  }  

  timeouts {
    create  = local.timeout_create
    delete  = local.timeout_delete
    read    = local.timeout_read
  }
}