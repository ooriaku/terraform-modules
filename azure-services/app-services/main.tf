locals {   
    connection_string_name  = var.db_connection_string_name != "" ? var.db_connection_string_name : null
    type		= var.db_connection_string_name != "" ? var.db_type : null
	value		= var.db_connection_string_name != "" ? "Server=tcp:${var.db_server_endpoint},1433;Initial Catalog=${var.db_name};Persist Security Info=False;User ID=${var.db_user_name};Password=${var.db_user_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;connection Timeout=30;" : null  
}


resource "azurerm_windows_web_app" "web" {
	name                = "${var.app_serv_name}"
	resource_group_name = "${var.resource_group_name}"
	location            = "${var.location}"
	tags		        = merge(tomap({"type" = "web"}), var.tags)

	service_plan_id					= var.service_plan_id 
	client_affinity_enabled			= false
	https_only						= true
	public_network_access_enabled 	= var.subnet_id == "" ? true : false
	
	
	identity {
        type         = "UserAssigned"
        identity_ids = [var.user_assigned_identity_id]
    }

	site_config {		
		ftps_state				= "AllAllowed"
		always_on				= var.app_service_alwayson
		minimum_tls_version		= "1.2"
		use_32_bit_worker		= true
		http2_enabled           = true
		vnet_route_all_enabled	= var.subnet_id == "" ? false : true
		
     
		application_stack {
			current_stack  = "dotnet"
			dotnet_version = "v8.0"
		}

		#For testing directly in the portal, set the app service to use the latest version of .NET Core.
		cors{
			allowed_origins = ["https://portal.azure.com"]
		}
	}
	app_settings = {
		"APPINSIGHTS_INSTRUMENTATIONKEY": "${var.app_insight_connection_string}",
		"APPLICATIONINSIGHTS_CONNECTION_STRING": "${var.app_insight_connection_string}",

		"WEBSITE_DNS_SERVER":  var.subnet_id == "" ? null : "168.63.129.16"
		#"WEBSITE_VNET_ROUTE_ALL": var.subnet_id == "" ? null : "1"

	}

	connection_string {
		name  = local.connection_string_name
		type  = local.type
		value = local.value
	}
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnet-integration" {
	#count			= var.subnet_id == "" ? 0 : 1
	app_service_id	= azurerm_windows_web_app.web.id
	subnet_id		= var.subnet_id
}

#  Deploy code from a public GitHub repo
resource "azurerm_app_service_source_control" "sourcecontrol" {
	app_id             		= azurerm_windows_web_app.web.id
	repo_url           		= var.repo_url #"https://github.com/Azure-Samples/nodejs-docs-hello-world"
	branch             		= var.repo_branch #"main"
	use_manual_integration 	= var.use_manual_integration  #true
	use_mercurial      		= var.use_mercurial  #false
}







