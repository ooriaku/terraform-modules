variable "storage_account_name" {
	type = string
}
variable "location" {
	type  = string
}

variable "resource_group_name" {
	type = string
}

variable "account_tier" {
	type = string
	default = "Standard"
}

variable "account_replication_type" {
	type	= string
	default = "LRS"
}

variable "virtual_network_subnet_ids" {
  description = "List of subnet IDs to allow access to the storage account"
  type        = list(string)
  default     = null  
}

variable "tags" {
  description = ""
  type        = map(any)
  default     = {}
}

variable "default_action" {
  description = "Default action for network rules"
  type        = string
  default     = "Allow"  
}
