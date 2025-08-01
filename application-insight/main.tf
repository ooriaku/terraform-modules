resource "azurerm_application_insights" "ai" {
    name                = "${var.ai_name}"
    location            = "${var.location}" 
    resource_group_name = "${var.resource_group_name}"
    application_type    = "web"
    tags                = var.tags

     workspace_id = var.workspace_id != "" ? var.workspace_id : null
}