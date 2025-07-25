resource "azurerm_virtual_machine_extension" "vm-custom-script" {
    name                 = var.virtual_machine_name
    virtual_machine_id   = var.virtual_machine_id
    publisher               = "Microsoft.Azure.Extensions"
    type                    = "CustomScript"
    type_handler_version    = "2.0"

  
    settings = <<SETTINGS
    {
      "fileUris": ["https://${var.script_storage_account_name}.blob.core.windows.net/${var.container_name}/${var.script_name}"],
      "commandToExecute": "bash ${var.script_name}"
    }
SETTINGS

    protected_settings = <<PROTECTED_SETTINGS
    {
        "storageAccountName": "${var.script_storage_account_name}",
        "storageAccountKey": "${var.script_storage_account_key}"
    }
PROTECTED_SETTINGS

    lifecycle {
        ignore_changes = [
            tags,
            settings,
            protected_settings
        ]
    }
}