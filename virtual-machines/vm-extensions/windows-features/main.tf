resource "azurerm_virtual_machine_extension" "vm-extensions" {
    name                 = "wsi-${var.virtual_machine_name}-ext" 
    virtual_machine_id   = var.virtual_machine_id
    publisher            = "Microsoft.Compute"
    type                 = "CustomScriptExtension"
    type_handler_version = "1.9"
    auto_upgrade_minor_version = true 
    tags                 = merge(var.tags, tomap({ "firstapply" = timestamp() }))
    settings = <<SETTINGS
    {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeManagementTools;"
    }
    SETTINGS  
}
