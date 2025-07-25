resource "azurerm_storage_account" "storage-account" {
	name                     	= var.storage_account_name
	resource_group_name      	= var.resource_group_name
	location                 	= var.location
	account_tier             	= var.account_tier
	account_replication_type 	= var.account_replication_type
	min_tls_version 			= "TLS1_2"
	tags					 	= var.tags
  
  
	network_rules {
		default_action       		= var.default_action #"Allow" #Deny
		bypass               		= ["AzureServices", "Logging","Metrics"]	
		virtual_network_subnet_ids 	= var.virtual_network_subnet_ids == null ? [] : var.virtual_network_subnet_ids
	}
}