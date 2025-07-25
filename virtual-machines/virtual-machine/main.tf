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


resource "azurerm_virtual_machine" "vm" {
    name                  = var.virtual_machine_name
    location              = var.location
    resource_group_name   = var.resource_group_name
    network_interface_ids = [azurerm_network_interface.nic.id]
    availability_set_id   = var.availability_set_id == "" ? null : var.availability_set_id
    vm_size               = var.vm_size 
    
    tags                  = merge(tomap({"type" = "server"}), var.tags)

    # Uncomment this line to delete the OS disk automatically when deleting the VM
    delete_os_disk_on_termination = var.delete_os_disk_on_termination

    # Uncomment this line to delete the data disks automatically when deleting the VM
    delete_data_disks_on_termination = var.delete_data_disks_on_termination

    storage_image_reference {
        publisher = var.publisher
        offer     = var.offer  
        sku       = var.sku
        version   = var.storage_version
    }
    storage_os_disk {
        name              = var.os_disk_name
        caching           = var.caching
        create_option     = var.create_option
        managed_disk_type = var.managed_disk_type
        disk_size_gb      = var.os_disk_size_gb
    }
    os_profile {
        computer_name  =  var.virtual_machine_name
        admin_username =  var.admin_username
        admin_password =  var.admin_password != null ? var.admin_password : random_password.admin_password.result  
    }
    os_profile_windows_config {
        #provision_vm_agent = var.provision_vm_agent
        provision_vm_agent = var.is_windows == true ? var.provision_vm_agent : null
    }
}
