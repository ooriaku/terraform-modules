variable "route_tables" {
  description = "Map of route tables and their route sets"
  type = map(object({
    name      = string
    subnet_id = string

    routes = map(object({
      address_prefix         = string
      next_hop_type          = string           # VirtualAppliance, VnetLocal, Internet, None
      next_hop_in_ip_address = optional(string) # Required when next_hop_type = VirtualAppliance
    }))

    disable_bgp_route_propagation = optional(bool, false)
  }))
}

variable "location" {
  type        = string
  description = "The name of the resource group in which to create the virtual network peering."
}

variable "resource_group_name" {

  description = "The full Azure resource ID of the remote virtual network."
}

variable "disable_bgp_route_propagation" {

  description = "The full Azure resource ID of the remote virtual network."
}

variable "tags" {
  description = "The tags to associate the resource we are creating"
  type        = map(any)
  default     = {}  
}

variable "subnet_ids" {
  description = "The full Azure resource ID of the remote virtual network."
  default     = ""
}

variable "routes" {
  description = "List of routes to be added to the route table"
  type                      = list(object({
    name                    = string
    address_prefix          = string
    next_hop_type           = string
    next_hop_in_ip_address  = optional(string)
  }))
  default     = [] 
}