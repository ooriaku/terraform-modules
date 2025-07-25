variable "location" {
	type	=	string
}

variable "firewall_name" {
	type	=	string
}

variable "tags" {
  description = ""
  type        = map(any)
  default     = {}
}

variable "firewall_sku_tier" {
	type        = string
	description = "Firewall SKU."
	default     = "Standard" # Valid values are Standard and Premium
	validation {
		condition = contains(["Basic", "Standard", "Premium"], var.firewall_sku_tier)
		error_message = "The sku must be one of the following: Basic, Standard, Premium"
	}
}

variable "firewall_sku_name" {
	description = "(Required) SKU name of the Firewall. Possible values are AZFW_Hub and AZFW_VNet. Changing this forces a new resource to be created."
	default     = "AZFW_VNet"
	type        = string

	validation {
		condition = contains(["AZFW_Hub", "AZFW_VNet" ], var.firewall_sku_name)
		error_message = "The value of the sku name property of the firewall is invalid."
	}
}

variable "resource_group_name" {
	type	=	string
}

variable "subnet_id" {
	type = string
}

variable "public_ip_address_id" {
	type = string
}

variable "policy_priority" {
	type	= number
	default = 500
}

variable "zones" {
  description = "Specifies the availability zones of the Azure Firewall"
  default     = ["1", "2", "3"]
  type        = list(string)
}

variable "application_rule_collections" {
	type = list(object({
		name     = string
		priority = number
		action   = string
		rules = list(object({
			name      = string
			protocols = list(object({
				type  = string
				port  = number
			}))
			source_addresses      = list(string)
			destination_fqdns     = list(string)
		}))
	}))
	default = []
}

variable "threat_intel_mode" {
	description = "(Optional) The operation mode for threat intelligence-based filtering. Possible values are: Off, Alert, Deny. Defaults to Alert."
	default     = "Alert"
	type        = string

	validation {
		condition = contains(["Off", "Alert", "Deny"], var.threat_intel_mode)
		error_message = "The threat intel mode is invalid."
	}
}

variable "nat_rule_collections" {
	type = list(object({
		name     = string
		priority = number
		action   = string
		rules = list(object({
			name                  = string
			protocols             = list(string)
			source_addresses      = list(string)
			destination_address   = string				
			destination_ports     = list(string)
			translated_address	  = string
			translated_port		  = string	
		}))
	}))
	default = []
}

variable "network_rule_collections" {
	type = list(object({
		name     = string
		priority = number
		action   = string
		rules = list(object({
			name                  = string
			protocols             = list(string)
			source_addresses      = list(string)
			destination_addresses = list(string)
			destination_ports     = list(string)
		}))
	}))
	default = []
}

