variable "app_serv_name" {
	type = string
}

variable "user_assigned_identity_id" {
	type = string
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the virtual network peering."
}

variable "location" {
  type = string
}

variable "db_connection_string_name" {
	type = string
	default = ""
}

variable "db_name" {
	type = string
	default = ""
}

variable "db_type" {
	type = string
	default = "SQLAzure"
}

variable "db_server_endpoint" {
	type = string
	default = ""
}

variable "db_user_name" {
	type = string
	default = ""
}

variable "db_user_password" {
	type = string
	default = ""
	sensitive = true
}

variable "repo_url" {
	type = string
	default = ""  
}

variable "repo_branch" {
	type = string
	default = "main"
}

variable "use_manual_integration" {
	type = bool
	default = false  
}

variable "use_mercurial" {
	type = bool
	default = false  
}



variable "service_plan_id" {
	type = string
}

variable "app_insight_instrumentation_key" {
	type = string
}

variable "app_insight_connection_string" {
	type = string
}


variable "subnet_id" {
	type = string
	default  = ""
}

variable "app_service_alwayson" {
	type = bool
	default = true
}

variable "tags" {
  description = ""
  type        = map(string)
  default     = {}
}