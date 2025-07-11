
resource "azurerm_eventhub_namespace" "ehn" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  capacity            = var.capacity

  auto_inflate_enabled     = var.auto_inflate != null ? var.auto_inflate.enabled : null
  maximum_throughput_units = var.auto_inflate != null ? var.auto_inflate.maximum_throughput_units : null
  tags                     = var.tags
}

resource "azurerm_eventhub_namespace_authorization_rule" "ehn-rule" {
  for_each = local.authorization_rules

  name                = each.key
  namespace_name      = azurerm_eventhub_namespace.ehn.name
  resource_group_name = var.resource_group_name

  listen = each.value.listen
  send   = each.value.send
  manage = each.value.manage
}

resource "azurerm_eventhub" "ehub" {
  for_each = local.hubs

  name                = each.key
  namespace_name      = azurerm_eventhub_namespace.ehn.name
  resource_group_name = var.resource_group_name
  partition_count     = each.value.partitions
  message_retention   = each.value.message_retention
}


resource "azurerm_eventhub_authorization_rule" "ehub-rule" {
  for_each = local.keys

  name                = each.value.key.name
  namespace_name      = azurerm_eventhub_namespace.ehn.name
  eventhub_name       = each.value.hub
  resource_group_name = var.resource_group_name

  listen = each.value.key.listen
  send   = each.value.key.send
  manage = false

  depends_on = [azurerm_eventhub.ehub]
}

resource "azurerm_eventhub_consumer_group" "ehub-cg" {
  for_each = local.consumers

  name                = each.value.name
  namespace_name      = azurerm_eventhub_namespace.ehn.name
  eventhub_name       = each.value.hub
  resource_group_name = var.resource_group_name
  user_metadata       = "terraform"

  depends_on = [azurerm_eventhub.ehub]
}
