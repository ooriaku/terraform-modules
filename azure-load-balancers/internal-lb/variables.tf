variable "lb_name" {
	type = string
}
variable "location" {
	type = string
}
variable "resource_group_name" {
	type = string
}

variable "subnet_id" {
	type = string
}
variable "enabled" {
	type    = bool
	default = true
}

variable "tags" {
  description = ""
  type        = map(any)
  default     = {}
}

variable "private_ip_address_allocation" {
	type = string
	default = "Dynamic"
	validation {
		condition     = contains(["Dynamic", "Static"], var.private_ip_address_allocation)
		error_message = "Valid values for var: private_ip_address_allocation are (Dynamic, Static)."
	} 
}

variable "private_ip_address" {
	type = string
	default = null
}

variable "network_interface_ids" {	
}

variable "ip_configuration_names" {

}