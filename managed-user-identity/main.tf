﻿# Get the current Subscription
data "azurerm_subscription" "current" {}

resource "azurerm_user_assigned_identity" "mi" {
  location            = var.location
  resource_group_name = var.resource_group_name 
  name                = var.managed_identity_name
  tags                = merge(tomap({"type" = "identity"}), var.tags)
}
