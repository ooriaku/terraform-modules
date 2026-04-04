
variable "dns_names" {
    description = ""
	type = list(string)
}   


variable "key_vault_id" {
    type = string
}

variable "key_vault_name" {
    type = string
  
}

variable "certificate_name" {
    type = string
}

variable "validity_in_months" {
    type = number
    default = 12    
}

variable "subject" {
    type = string
}

variable "days_before_expiry" {
    type = number
    default = 30
}