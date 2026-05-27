variable "resource_group_name" {
    description = "The name of the resource group in which to create the API Management instance."
    type        = string
  
}

variable "location" {
    description = "The Azure region where the API Management instance will be created."
    type        = string
}

variable "name" {
    description = "The name of the API Management instance."
    type        = string
}

variable "publisher_name" {
    description = "The name of the publisher for the API Management instance."
    type        = string
}

variable "publisher_email" {
    description = "The email of the publisher for the API Management instance."
    type        = string
}

variable "sku_name" {
    description = "The SKU name of the API Management instance."
    type        = string
}

variable "tags" {
    description = "A map of tags to assign to the API Management instance."
    type        = map(string)
}
variable "user_assigned_identity_id" {
    description = "The resource ID of a user-assigned managed identity to associate with the API Management instance."
    type        = string
    default     = null
}

variable "identity_type" {
    description = "The type of managed identity to use for the API Management instance. Valid values are 'SystemAssigned', 'UserAssigned', or 'None'."
    type        = string
    default     = "None"
}

variable "global_policy_xml" {
    description = "XML policy content to apply at the global (API Management instance) level."
    type        = string
    default     = null
}

variable "products" {
    description = "A list of products to create within the API Management instance."
    type = list(object({
        product_id            = string
        display_name          = string
        published             = bool
        subscription_required = bool
        approval_required     = optional(bool, false)
        subscriptions_limit   = optional(number)
        description           = optional(string)
        terms                 = optional(string)
        api_names             = optional(list(string), [])
        policy_xml            = optional(string)
    }))
    default = []
}

variable "subscriptions" {
    description = "A list of subscriptions to create. Scope to a product via product_id or a single API via api_name."
    type = list(object({
        display_name  = string
        product_id    = optional(string)
        api_name      = optional(string)
        state         = optional(string, "active")
        allow_tracing = optional(bool, false)
    }))
    default = []
}

variable "apis" {
    description = "A list of APIs to create within the API Management instance, each with optional operations."
    type = list(object({
        name         = string
        revision     = string
        display_name = string
        path         = string
        protocols    = list(string)
        service_url  = optional(string)
        policy_xml   = optional(string)
        operations   = optional(list(object({
            operation_id  = string
            display_name  = string
            method        = string
            url_template  = string
            description   = optional(string)
            policy_xml    = optional(string)
        })), [])
    }))
    default = []
}