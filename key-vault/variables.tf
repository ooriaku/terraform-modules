variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the virtual network peering."
}

variable "location" {
  type        = string
  description = "The full Azure resource ID of the remote virtual network."
}

variable "managed_identity_name" {
  type        = string
  description = "The full Azure resource ID of the remote virtual network."
}

variable "key_vault_name" {
  type        = string
  description = "The full Azure resource ID of the remote virtual network."
}

variable "sku_name" {
  type        = string
  description = "The full Azure resource ID of the remote virtual network."
}

variable "enabled_for_deployment" {
  type        = string
  description = "Allow Azure Virtual Machines to retrieve certificates stored as secrets from the Azure Key Vault"
  default     = "true"
}

variable "enabled_for_disk_encryption" {
  type        = string
  description = "Allow Azure Disk Encryption to retrieve secrets from the Azure Key Vault and unwrap keys" 
  default     = "true"
}

variable "enabled_for_template_deployment" {
  type        = string
  description = "Allow Azure Resource Manager to retrieve secrets from the Azure Key Vault"
  default     = "true"
}

variable "admin_certificate_permissions" {
  description = "The full Azure resource ID of the remote virtual network."
}

variable "admin_key_permissions" {
  description = "The full Azure resource ID of the remote virtual network."
}

variable "admin_secret_permissions" {
  description = "The full Azure resource ID of the remote virtual network."
}

variable "admin_storage_permissions" {
  description = "The full Azure resource ID of the remote virtual network."
}

variable "managed_identity_secret_permissions" {
  description = "The full Azure resource ID of the remote virtual network."
}

variable "managed_identity_key_permissions" {
  description = "The full Azure resource ID of the remote virtual network."
}

variable "managed_identity_certificate_permissions" {
  description = "The full Azure resource ID of the remote virtual network."
}

variable "managed_identity_storage_permissions" {
  description = "The full Azure resource ID of the remote virtual network."
}

variable "managed_identity_test_object_id" {
  description = "The full Azure resource ID of the remote virtual network."
  default     = ""
}

variable "tags" {
  description = "The tags to associate the resource we are creating"
  type        = map(any)
  default     = {}
}

variable "managed_identity_principal_id" {
  description = "The full Azure resource ID of the remote virtual network."
  default     = ""
  
}