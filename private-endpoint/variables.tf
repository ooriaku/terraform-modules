variable "location" {
  type        = string
  description = "The name of the resource group in which to create the virtual network peering."
}

variable "pvt_endpoint_name" {
  type        = string
  description = "The name of the resource group in which to create the virtual network peering."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the virtual network peering."
}

variable "subnet_id" {
  description = "The name of the resource group in which to create the virtual network peering."
}

variable "private_service_connection_name" {
  description = "The name of the resource group in which to create the virtual network peering."
}

variable "is_manual_connection" {
  description = "The name of the resource group in which to create the virtual network peering."
}

variable "private_connection_resource_id" {
  description = "The name of the resource group in which to create the virtual network peering."
}

variable "subresource_names" {
  description = "The name of the resource group in which to create the virtual network peering."
}

variable "dns" {
    description = "The Details of the private DNS Zone where the Private Endpoint will register."
    type = object({
        zone_ids  = list(string) 
        zone_name = string
    })
}


variable "tags" {
  description = "The tags to associate the resource we are creating"
  type        = map(any)
  default     = {}
}