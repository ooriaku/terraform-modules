variable "public_ip_name" {
  type        = string
  description = "The full Azure resource ID of the remote virtual network."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the virtual network peering."
}

variable "location" {
  type = string
}

variable "allocation_method" {
  type        = string
  description = "The full Azure resource ID of the remote virtual network."
}

variable "sku" {
  type        = string
  description = "The full Azure resource ID of the remote virtual network."
}

variable "tags" {
  description = "The tags to associate the resource we are creating"
  type        =  map(any)
  default     = {}
}

variable "zones" {
	description = "A collection of availability zones to spread the Public IP over."
	type        = list(string)
	default     = [] #["1", "2", "3"]
}