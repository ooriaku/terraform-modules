resource "random_password" "password" {
  count            = var.password == "" ? 1 : 0
  length           = 16
  special          = true
  upper            = true
  lower            = true
  min_lower        = 1
  min_numeric      = 1
  min_upper        = 1
  override_special = "_%@"
}

#########################################################
# Create a Network Interface
#########################################################
resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  ip_configuration {
    name                          = "ipconfiguration"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}


#########################################################
# Create a Windows Virtual Machine
#########################################################
resource "azurerm_windows_virtual_machine" "mssqlvm" {
  name                  = var.vm_name
  computer_name         = substr(var.vm_name, 0, 15)
  resource_group_name   = var.resource_group_name
  location              = var.location
  tags                  = var.tags
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = var.vm_size
  admin_username        = var.username
  admin_password        = var.password == "" ? random_password.password[0].result : var.password
  zone                  = var.zone != "" ? var.zone : null
  # availability_set_id   = var.availability_set_id
  # custom_data           = var.custom_data
  license_type          = var.license_type

  # enable_automatic_updates   = var.enable_automatic_updates
  # provision_vm_agent         = var.provision_vm_agent
  provision_vm_agent         = true
  encryption_at_host_enabled = var.encryption_at_host_enabled

  os_disk {
    name                   = "${var.vm_name}-osdisk"
    caching                = "ReadWrite"
    storage_account_type   = var.os_disk_type
    disk_size_gb           = var.os_disk_size_gb
    disk_encryption_set_id = var.disk_encryption_set_id
  }
  

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku    
    version   = "latest"
  }

  dynamic "identity" {
    for_each = var.enable_system_identity == true ? var.user_identity_ids == null ? ["SystemAssigned"] : ["SystemAssigned, UserAssigned"] : var.user_identity_ids == null ? [] : ["UserAssigned"]
    content {
      type         = identity.value
      identity_ids = var.user_identity_ids
    }
  }
}

# Data Disk 1 - SQL Data
resource "azurerm_managed_disk" "sql-data-disk" {
  name                   = "${var.vm_name}-sql-data-disk"
  resource_group_name    = var.resource_group_name
  location               = var.location
  tags                   = var.tags
  storage_account_type   = var.sa_disk_type #"Premium_LRS"
  create_option          = "Empty"
  disk_size_gb           = 256 #256
  zone                   = var.zone != "" ? var.zone : null
  disk_encryption_set_id = var.disk_encryption_set_id
  
}

# Data Disk 2 - SQL Logs
resource "azurerm_managed_disk" "sql-log-disk" {
  name                   = "${var.vm_name}-sql-log-disk"
  resource_group_name    = var.resource_group_name
  location               = var.location
  tags                   = var.tags
  storage_account_type   = var.sa_disk_type #"Premium_LRS"
  create_option          = "Empty"
  disk_size_gb           = 128              #128 
  zone                   = var.zone != "" ? var.zone : null
  disk_encryption_set_id = var.disk_encryption_set_id 
}

# Data Disk 3 - SQL Backups
resource "azurerm_managed_disk" "sql-backup-disk" {
  name                   = "${var.vm_name}-sql-backup-disk"
  resource_group_name    = var.resource_group_name
  location               = var.location
  tags                   = var.tags
  storage_account_type   = var.sa_disk_type #"Premium_LRS"
  create_option          = "Empty"
  disk_size_gb           = 512              #128 
  zone                   = var.zone != "" ? var.zone : null
  disk_encryption_set_id = var.disk_encryption_set_id 
}

resource "azurerm_virtual_machine_data_disk_attachment" "sql-data-attach" {
  managed_disk_id    = azurerm_managed_disk.sql-data-disk.id
  virtual_machine_id = azurerm_windows_virtual_machine.mssqlvm.id
  lun                = 0
  caching            = "ReadOnly"
}

resource "azurerm_virtual_machine_data_disk_attachment" "sql-log-attach" {
  managed_disk_id    = azurerm_managed_disk.sql-log-disk.id
  virtual_machine_id = azurerm_windows_virtual_machine.mssqlvm.id
  lun                = 1
  caching            = "None"
}

resource "azurerm_virtual_machine_data_disk_attachment" "sql-backup-attach" {
  managed_disk_id    = azurerm_managed_disk.sql-backup-disk.id
  virtual_machine_id = azurerm_windows_virtual_machine.mssqlvm.id
  lun                = 2
  caching            = "ReadOnly"
}


resource "azurerm_mssql_virtual_machine" "sqlvm" {
  virtual_machine_id               = azurerm_windows_virtual_machine.mssqlvm.id
  sql_license_type                 = "PAYG"
  sql_connectivity_port            = 1433
  sql_connectivity_type            = "PRIVATE"
  sql_connectivity_update_password = var.password == "" ? random_password.password[0].result : var.password
  sql_connectivity_update_username = var.sqladminname
  tags                             = var.tags

  dynamic "auto_patching" {
    for_each = var.patching

    content {
      day_of_week                            = auto_patching.value.day_of_week
      maintenance_window_duration_in_minutes = auto_patching.value.maintenance_window_duration_in_minutes
      maintenance_window_starting_hour       = auto_patching.value.maintenance_window_starting_hour
    }
  }
  storage_configuration {
    disk_type             = "NEW"
    storage_workload_type = "OLTP"
    data_settings {
      default_file_path = "F:\\data"
      luns              = [0]
    }
    log_settings {
      default_file_path = "G:\\logs"
      luns              = [1]
    }
    temp_db_settings {
      default_file_path = "H:\\tempdb"
      luns              = [2]
    }
  }
  depends_on = [
    azurerm_virtual_machine_data_disk_attachment.sql-backup-attach,
    azurerm_virtual_machine_data_disk_attachment.sql-data-attach,
    azurerm_virtual_machine_data_disk_attachment.sql-log-attach,
  ]
}