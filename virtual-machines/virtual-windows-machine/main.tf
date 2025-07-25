#SA Password should be changed once VM is stood up and configured.
resource "random_password" "admin_password" {  
    length      = 20
    special     = true
    min_numeric = 1
    min_upper   = 1
    min_lower   = 1
    min_special = 1
}

resource "azurerm_network_interface" "nic" {
    name                = var.nic_name
    location            = var.location
    resource_group_name = var.resource_group_name
    tags                = merge(tomap({"type" = "server"}), var.tags)

    ip_configuration {
        name                          = var.ipconfig_name
        subnet_id                     = var.subnet_id
        private_ip_address_allocation = var.private_ip_address_allocation
        private_ip_address            = var.private_ip_address
        public_ip_address_id          = var.public_ip_address_id
    }
}

resource "azurerm_windows_virtual_machine" "vm" {
    name                        = var.vm_name
    location                    = var.location
    resource_group_name         = var.resource_group_name
    tags                        = merge(tomap({"type" = "server"}), var.tags)
    network_interface_ids       = [azurerm_network_interface.nic.id]
    admin_username              = var.admin_username
    admin_password              = var.admin_password != null ? var.admin_password : random_password.admin_password.result  
    size                        = var.size
    #priority                    = var.priority
    #eviction_policy             = var.eviction_policy
    enable_automatic_updates    = var.enable_automatic_updates
    provision_vm_agent          = true
    encryption_at_host_enabled  = var.encryption_at_host_enabled
    availability_set_id         = var.availability_set_id == "" ? null : var.availability_set_id
    license_type                = var.license_type
    computer_name               = var.vm_name

    os_disk {
        name                 = "${var.vm_name}-osdisk"
        caching              = "ReadWrite"
        storage_account_type = var.os_disk_storage_account_type
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

    boot_diagnostics {        
        storage_account_uri = var.boot_diagnostics_storage_uri == "" ? null : var.boot_diagnostics_storage_uri
    }
}