variable "vm_name" {
  description = "The name of the virtual machine"
  type        = string  
}

variable "priority" {
  description = "The priority of the virtual machine"
  type        = string
  default     = "Regular"  
}

variable "eviction_policy" {
  description = "The eviction policy of the virtual machine"
  type        = string
  default     = "Deallocate"  
}

variable "enable_automatic_updates" {
  description = "Enable automatic updates"
  type        = bool
  default     = true  
}

variable "license_type" {
  description = "The license type of the virtual machine"
  type        = string
  default     = "Windows_Server"  
}

variable "os_disk_storage_account_type" {
  description = "The storage account type of the OS disk"
  type        = string
  default     = "Standard_LRS"  
}


variable "admin_username" {
  description = "The username for the VM"
  type        = string  
}

variable "admin_password" {
  description = "The password for the VM"
  type        = string  
}

variable "availability_set_id" {
  description = "The ID of the availability set"
  type        = string
  default     = ""
}

variable "publisher" {
  description = "The publisher of the image"
  type        = string
  default     = "MicrosoftWindowsServer"  
}

variable "offer" {
  description = "The offer of the image"
  type        = string
  default     = "WindowsServer"  
}

variable "sku" {
  description = "The SKU of the image"
  type        = string
  default     = "2019-Datacenter"  
}

variable "size" {
  description = "The size of the VM"
  type        = string
  default     = "Standard_DS2_v2"  
}

variable "location" {
  description = "The location/region where the virtual machine will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which the virtual machine will be created"
  type        = string
}

variable "nic_name" {
  description = "The name of the network interface card"
  type        = string
}

variable "ipconfig_name" {
  description = "The name of the IP configuration"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {
    type = "server"
  }
}

variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
}

variable "private_ip_address_allocation" {
  description = "The allocation method of the private IP address"
  type        = string
  default     = "Dynamic"  
}

variable "private_ip_address" {
    description = "The private IP address"
    type        = string
    default     = null
}

variable "public_ip_address_id" {
    description = "The ID of the public IP address"
    type        = string
    default     = null
}

variable "provision_vm_agent" {
  type        = bool
  description = "Whether to provision the VM agent"
  default     = true
}

variable "encryption_at_host_enabled" {
  type        = bool
  default     = false
  description = "Should all of the disks (including the temp disk) attached to this Virtual Machine be encrypted by enabling Encryption at Host?"
}

variable "enable_system_identity" {
  type        = bool
  description = "Whether to enable system identity. true or false"
  default     = true
}

variable "os_disk_size_gb" {
  type        = number
  description = "Size of the OS disk"
  default     = 127
}

variable "disk_encryption_set_id" {
  type        = string
  description = "Encryption set to use to encypt the OS and data disks"
  default     = null
}

variable "user_identity_ids" {
  type        = list(string)
  default     = null
  description = "User identities to be assigned"
}

variable "boot_diagnostics_storage_uri" {
  type        = string
  default     = ""
  description = "The URI of the storage account to use for boot diagnostics"  
}