variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  default     = ""
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = ""
}
variable "app_gateway_name" {
  description = "The name of the Application Gateway"
  default     = ""
}

variable "enable_http2" {
  description = "Is HTTP2 enabled on the application gateway resource?"
  default     = false
}

variable "public_ip_address_id" {
  description = "The ID of the Public IP Address to associate with the Application Gateway. If not specified, a new Public IP Address will be created."
  default     = null
  
}
variable "zones" {
  description = "A collection of availability zones to spread the Application Gateway over."
  type        = list(string)
  default     = [] #["1", "2", "3"]
}


variable "ssl_policy" {
  description = "SSL Policy to be used for Application Gateway"
  type = object({
    policy_type = string
    policy_name = optional(string)
    disabled_ssl_protocols = optional(list(string))
    cipher_suites = optional(list(string))
    min_protocol_version = optional(string)
  })
  default = null
} 

variable "sku" {
  description = "The sku pricing model of v1 and v2"
  type = object({
    name     = string
    tier     = string
    capacity = optional(number)
  })
}

variable "autoscale_configuration" {
  description = "Minimum or Maximum capacity for autoscaling. Accepted values are for Minimum in the range 0 to 100 and for Maximum in the range 2 to 125"
  type = object({
    min_capacity = number
    max_capacity = optional(number)
  })
  default = null
}

variable "private_ip_address" {
  description = "Private IP Address to assign to the Load Balancer."
  default     = null
}

variable "backend_address_pools" {
  description = "List of backend address pools"
  type = list(object({
    name         = string
    fqdns        = optional(list(string))
    ip_addresses = optional(list(string))
  }))
}

variable "backend_http_settings" {
  description = "List of backend HTTP settings."
  type = list(object({
    name                                = string
    cookie_based_affinity               = string
    affinity_cookie_name                = optional(string)
    path                                = optional(string)
    enable_https                        = bool
    probe_name                          = optional(string)
    request_timeout                     = number
    host_name                           = optional(string)
    pick_host_name_from_backend_address = optional(bool)
    authentication_certificate = optional(object({
      name = string
    }))
    trusted_root_certificate_names = optional(list(string))
    connection_draining = optional(object({
      enable_connection_draining = bool
      drain_timeout_sec          = number
    }))
  }))
}

variable "http_listeners" {
  description = "List of HTTP/HTTPS listeners. SSL Certificate name is required"
  type = list(object({
    name                 = string
    host_name            = optional(string)
    host_names           = optional(list(string))
    require_sni          = optional(bool)
    ssl_certificate_name = optional(string)
    firewall_policy_id   = optional(string)
    ssl_profile_name     = optional(string)
    custom_error_configuration = optional(list(object({
      status_code           = string
      custom_error_page_url = string
    })))
  }))
}

variable "request_routing_rules" {
  description = "List of Request routing rules to be used for listeners."
  type = list(object({
    name                        = string
    rule_type                   = string
    http_listener_name          = string
    backend_address_pool_name   = optional(string)
    backend_http_settings_name  = optional(string)
    redirect_configuration_name = optional(string)
    rewrite_rule_set_name       = optional(string)
    url_path_map_name           = optional(string)
  }))
  default = []
}

variable "identity_ids" {
  description = "Specifies a list with a single user managed identity id to be assigned to the Application Gateway"
  default     = null
}

variable "authentication_certificates" {
  description = "Authentication certificates to allow the backend with Azure Application Gateway"
  type = list(object({
    name = string
    data = string
  }))
  default = []
}

variable "trusted_root_certificates" {
  description = "Trusted root certificates to allow the backend with Azure Application Gateway"
  type = list(object({
    name = string
    data = string
  }))
  default = []
}

variable "ssl_certificates" {
  description = "List of SSL certificates data for Application gateway"
  type = list(object({
    name                      = string
    data                      = optional(string)
    password                  = optional(string)
    key_vault_secret_id       = optional(string)
    key_vault_secret_version  = optional(string)
  }))
  default = []
}

variable "health_probes" {
  description = "List of Health probes used to test backend pools health."
  type = list(object({
    name                                      = string
    host                                      = string
    interval                                  = number
    path                                      = string
    timeout                                   = number
    unhealthy_threshold                       = number
    port                                      = optional(number)
    pick_host_name_from_backend_http_settings = optional(bool)
    minimum_servers                           = optional(number)
    match = optional(object({
      body        = optional(string)
      status_code = optional(list(string))
    }))
  }))
  default = []
}

variable "url_path_maps" {
  description = "List of URL path maps associated to path-based rules."
  type = list(object({
    name                                = string
    default_backend_http_settings_name  = optional(string)
    default_backend_address_pool_name   = optional(string)
    default_redirect_configuration_name = optional(string)
    default_rewrite_rule_set_name       = optional(string)
    path_rules = list(object({
      name                        = string
      backend_address_pool_name   = optional(string)
      backend_http_settings_name  = optional(string)
      paths                       = list(string)
      redirect_configuration_name = optional(string)
      rewrite_rule_set_name       = optional(string)
      firewall_policy_id          = optional(string)
    }))
  }))
  default = []
}

variable "redirect_configuration" {
  description = "list of maps for redirect configurations"
  type        = list(map(string))
  default     = []
}

variable "custom_error_configuration" {
  description = "Global level custom error configuration for application gateway"
  type        = list(map(string))
  default     = []
}

variable "rewrite_rule_set" {
  description = "List of rewrite rule set including rewrite rules"
  type        = any
  default     = []
}

variable "rule_group_overrides" {
  type = map(list(object({
    id      = string
    enabled = bool
  })))
}

variable "waf_configuration" {
  description = "Web Application Firewall support for your Azure Application Gateway"
  type = object({
    firewall_mode            = string
    rule_set_version         = string
    file_upload_limit_mb     = optional(number)
    request_body_check       = optional(bool)
    max_request_body_size_kb = optional(number)
    disabled_rule_group = optional(list(object({
      rule_group_name = string
      rules           = optional(list(string))
    })))
    exclusion = optional(list(object({
      match_variable          = string
      selector_match_operator = optional(string)
      selector                = optional(string)
    })))
  })
  default = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "subnet_id" {
  description = "The ID of the subnet where the Application Gateway will be deployed"
  default     = null
}
