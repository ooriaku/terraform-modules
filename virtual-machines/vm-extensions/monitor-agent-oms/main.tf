resource "azurerm_virtual_machine_extension" "vm-ext-oms" {
    name                       = "${var.virtual_machine_name}"
	virtual_machine_id         = "${var.virtual_machine_id}"

    publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
    type                       = "OmsAgentForLinux"
    type_handler_version       = "1.12"
    auto_upgrade_minor_version = true
 
    settings = <<SETTINGS
    {
        "workspaceId": "${var.log_analytics_workspace_id}"
    }
    SETTINGS
 
    protected_settings = <<PROTECTED_SETTINGS
    {
        "workspaceKey": "${var.log_analytics_workspace_key}"
    }
    PROTECTED_SETTINGS

    lifecycle {
        ignore_changes = [
            tags
        ]
    }
  
}