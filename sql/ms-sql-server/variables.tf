variable "location" {
  description = "Region to deploy into."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group to be deployed to."
  type        = string
}

variable "vm_name" {
  type        = string
  description = "Hardcoded name for VM"
  default     = ""
}

variable "tags" {
  type        = map(any)
  description = "A list of tags to be applied"
  default     = {}
}

variable "subnet_id" {
  type        = string
  description = "The subnets to create nic in."
}

variable "release" {
  type        = string
  description = "The release/instance number of the VM - used for the name of the VM"
  default     = "001"
}

variable "vm_size" {
  type        = string
  description = "The size/sku of the VM to be created"
}

variable "username" {
  type        = string
  description = "Username of the VM"
  default     = "adminuser"
}

variable "sqladminname" {
  type        = string
  description = "Username of the SQL admin"
  default     = "sqladmin"
}
variable "offer" {
  type        = string
  description = "Offer of the image"
  default     = "SQL2017-WS2016"
}

variable "sku" {
  type        = string
  description = "SKU for the MS SQL image"
  default     = "SQLDEV"
}

variable "publisher" {
  type        = string
  description = "Publisher of the image"
  default     = "MicrosoftSQLServer"
}

variable "data_disk_size" {
  type        = string
  description = "Size of the data disk"
  default     = 1000
}

variable "logs_disk_size" {
  type        = string
  description = "Size of the logs disk"
  default     = 500
}

variable "tempdb_disk_size" {
  type        = string
  description = "Size of the tempdb disk"
  default     = 200
}

variable "password" {
  type        = string
  description = "Password for the VM and sqladmin account. If not supplied it is auto generated"
  default     = ""
}

variable "patching" {
  type = list(object({
    day_of_week                            = string,
    maintenance_window_duration_in_minutes = string,
    maintenance_window_starting_hour       = string
  }))
  description = "patching schedule to apply"
  default     = []
}

variable "zone" {
  type        = string
  default     = ""
  description = "The Zone in which this Virtual Machine should exist"
}

variable "sa_disk_type" {
  type        = string
  default     = "Premium_LRS"
  description = "The disk type to be used"
}

variable "os_disk_type" {
  type        = string
  description = "Type of OS disk"
  default     = "Standard_LRS"
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

variable "enable_system_identity" {
  type        = bool
  description = "Whether to enable system identity. true or false"
  default     = true
}

variable "encryption_at_host_enabled" {
  type        = bool
  default     = false
  description = "Should all of the disks (including the temp disk) attached to this Virtual Machine be encrypted by enabling Encryption at Host?"
}

variable "license_type" {
  description = "Specifies the type of on-premise license (also known as Azure Hybrid Use Benefit) which should be used for this Virtual Machine. Possible values are None, Windows_Client and Windows_Server"
  type        = string
  default     = null
}

variable "provision_vm_agent" {
  type        = bool
  description = "Whether to provision the VM agent"
  default     = true
}

variable "firewall_rules" {
  description = "A list of firewall rules"
  type = list(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
  default = [{
    name             = "all"
    start_ip_address = "0.0.0.0"
    end_ip_address   = "255.255.255.255"
  }]
}

variable "nic_name" {
  type        = string
  description = "Name of the NIC"
  default     = "nic"
  
}