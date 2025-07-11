variable "domain_password" {
	type      = string
	sensitive = true
}

variable "domain_name" {
	type      = string	
}

variable "domain_user_upn" {
	type      = string	
}

variable "virtual_machine_name" {
	type      = string	
}

variable "virtual_machine_id" {
	type      = string	
}    

variable "ou_path" {
	type    = string
	default = ""
}