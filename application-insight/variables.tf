variable "resource_group_name" {
  description = ""
  type = string
}

variable "ai_name" {
  type = string
}

variable "location" {
  description = ""
  type = string
}

variable "workspace_id" {
  description = ""
  type        = string
  default     = ""
  
}
variable "tags" {
  description = ""
  type        = map(any)
  default     = {}
}
