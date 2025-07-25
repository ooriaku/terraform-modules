variable "availability_set_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "tags" {
  description = "The tags to associate the resource we are creating"
  type        = map(string)
  default     = {}
}

variable "platform_fault_domain_count" {
  description = "The number of fault domains for this availability set"
  type        = number
  default     = 2  
}

variable "platform_update_domain_count" {
  description = "The number of update domains for this availability set"
  type        = number
  default     = 5  
}