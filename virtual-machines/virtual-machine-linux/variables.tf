variable "nic_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "delete_os_disk_on_termination" {
  description = "The full Azure resource ID of the remote virtual network."
}

variable "delete_data_disks_on_termination" {
  description = "The full Azure resource ID of the remote virtual network."
}

variable "os_disk_storage_account_type" {
  description = ""
}

variable "boot_diagnostics_storage_account" {
  default = ""
}

variable "ipconfig_name" {
 type = string
}

variable "availability_set_id" {
	type	=	string
	default = ""
}
variable "subnet_id" {
  description = "The full Azure resource ID of the remote virtual network."
}

variable "private_ip_address_allocation" {
  description = "The full Azure resource ID of the remote virtual network."
}

variable "private_ip_address" {
	description = "The private ip address for the virtual machine"
	default = null
}

variable "public_ip_address_id" {
  type    = string
  default = null
}

variable "virtual_machine_name" {
  description = "The full Azure resource ID of the remote virtual network."
}

variable "vm_size" {
  description = "The full Azure resource ID of the remote virtual network."
  default = "Standard_DS1_v2"
}


variable "publisher" {
  description = "The full Azure resource ID of the remote virtual network."
  default = "Canonical"
}

variable "offer" {
  description = "The full Azure resource ID of the remote virtual network."
  default = "UbuntuServer"
}

variable "sku" {
  description = "The full Azure resource ID of the remote virtual network."
  default = "18.04-LTS"
}

variable "storage_version" {
  description = "The full Azure resource ID of the remote virtual network."
}

variable "os_disk_name" {
  description = "The full Azure resource ID of the remote virtual network."
}

variable "caching" {
  description = "The full Azure resource ID of the remote virtual network."
}


variable "managed_disk_type" {
  description = "The full Azure resource ID of the remote virtual network."
}


variable "admin_username" {
  type        = string
  description = "The administrator username of the SQL logical server."
  default     = "azureadmin"
}

variable "admin_ssh_public_key" {
  type        = string
  description = "The administrator password of the vm server."
  sensitive   = true
  default     = null
}

variable "provision_vm_agent" {
  description = "The full Azure resource ID of the remote virtual network."
}

variable "tags" {
  description = "The tags to associate the resource we are creating"
  type        = map(string)
  default     = {}
}