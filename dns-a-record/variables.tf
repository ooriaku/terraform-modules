variable "azure_resource_name" {
	type = string
}

variable "private_dns_zone_name" {
	type = string
}

variable "resource_group_name" {
	type = string
}



variable "private_ip_address" {
	type = string
}

variable "tags" {
  description = "The tags to associate the resource we are creating"
  type        = map(any)
  default     = {}
}



