
resource "azurerm_network_interface" "nic" {
    name                = var.nic_name
    location            = var.location
    resource_group_name = var.resource_group_name
    tags		        = var.tags

    ip_configuration {
        name                          = var.ipconfig_name
        subnet_id                     = var.subnet_id
        private_ip_address_allocation = var.private_ip_address_allocation
        private_ip_address            = var.private_ip_address
        public_ip_address_id          = var.public_ip_address_id
    }
    lifecycle {
        ignore_changes = [
            tags
        ]
    }
}


resource "azurerm_linux_virtual_machine" "vm" {
    name                  = var.virtual_machine_name
    location              = var.location
    resource_group_name   = var.resource_group_name
  
    
    
    network_interface_ids = [azurerm_network_interface.nic.id]
    availability_set_id   = var.availability_set_id == "" ? null : var.availability_set_id
    size               = var.vm_size 
    computer_name         = var.virtual_machine_name
    admin_username        = var.admin_username
    tags		          = var.tags
    provision_vm_agent    = true

    # Uncomment this line to delete the OS disk automatically when deleting the VM
    #delete_os_disk_on_termination = var.delete_os_disk_on_termination

    # Uncomment this line to delete the data disks automatically when deleting the VM
    #delete_data_disks_on_termination = var.delete_data_disks_on_termination
   
    os_disk {
        name                 = "${var.virtual_machine_name}osDisk"
        caching              = "ReadWrite"
        storage_account_type = var.os_disk_storage_account_type
        disk_size_gb         = 128
    }
  
    admin_ssh_key {
        username   = var.admin_username
        public_key = var.admin_ssh_public_key
    }

    source_image_reference {
        publisher = var.publisher
        offer     = var.offer  
        sku       = var.sku
        version   = var.storage_version
    }

    boot_diagnostics {
        storage_account_uri = var.boot_diagnostics_storage_account == "" ? null : var.boot_diagnostics_storage_account
    }

    lifecycle {
        ignore_changes = [
            tags
        ]
    }
}