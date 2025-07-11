variable "location" {
  description = "The location/region where the DNS resolver should be created."
  type        = string  
}

variable "private_dns_resolver_name" {
  description = "The name of the DNS resolver."
  type        = string   
}

variable "private_dns_resolver_inbound_endpoint_name" {
  description = "The name of the inbound endpoint."
  type        = string   
}

variable "private_dns_resolver_outbound_endpoint_name" {
  description = "The name of the outbound endpoint."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which the DNS resolver should be created."
  type        = string  
}

variable "virtual_network_id" {
  description = "The ID of the virtual network in which the DNS resolver should be created."
  type        = string  
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)  
}

variable "inbound_subnet_id" {
  description = "The ID of the subnet in which the inbound endpoint should be created."
  type        = string 
}

variable "outbound_subnet_id" {
  description = "The ID of the subnet in which the outbound endpoint should be created."
  type        = string  
}
