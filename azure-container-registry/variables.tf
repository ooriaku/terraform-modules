variable "acr_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "sku" {
  type = string
  default = "Premiumm"
}
variable "admin_enabled" {
	type = bool
	default = false
}

variable "tags" {
  description = "The tags to associate the resource we are creating"
  type        = map(any)
  default     = {}
}

variable "identity_ids" {
  description = "Specifies a list of user managed identity ids to be assigned. This is required when `type` is set to `UserAssigned` or `SystemAssigned, UserAssigned`"
  default     = null
}

