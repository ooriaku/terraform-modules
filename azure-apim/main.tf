resource "azurerm_api_management" "apim" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  sku_name            = var.sku_name
  tags                = var.tags

  identity {
		type         = var.identity_type
		identity_ids = var.identity_type == "UserAssigned" ? [var.user_assigned_identity_id] : null
   }

}

resource "azurerm_api_management_api" "apis" {
  for_each = { for api in var.apis : api.name => api }

  name                = each.key
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.apim.name
  revision            = each.value.revision
  display_name        = each.value.display_name
  path                = each.value.path
  protocols           = each.value.protocols
  service_url         = each.value.service_url
}


resource "azurerm_api_management_api_operation" "operations" {
  for_each = { for op in local.api_operations : op.key => op }

  operation_id        = each.value.operation_id
  api_name            = each.value.api_name
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  display_name        = each.value.display_name
  method              = each.value.method
  url_template        = each.value.url_template
  description         = each.value.description

  depends_on = [azurerm_api_management_api.apis]
}

resource "azurerm_api_management_product" "products" {
  for_each = { for p in var.products : p.product_id => p }

  product_id            = each.key
  resource_group_name   = var.resource_group_name
  api_management_name   = azurerm_api_management.apim.name
  display_name          = each.value.display_name
  published             = each.value.published
  subscription_required = each.value.subscription_required
  approval_required     = each.value.subscription_required ? each.value.approval_required : null
  subscriptions_limit   = each.value.subscriptions_limit
  description           = each.value.description
  terms                 = each.value.terms
}

resource "azurerm_api_management_product_api" "product_apis" {
  for_each = { for pa in local.product_apis : pa.key => pa }

  product_id          = each.value.product_id
  api_name            = each.value.api_name
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name

  depends_on = [
    azurerm_api_management_product.products,
    azurerm_api_management_api.apis,
  ]
}

resource "azurerm_api_management_subscription" "subscriptions" {
  for_each = { for s in var.subscriptions : s.display_name => s }

  api_management_name = azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  display_name        = each.value.display_name
  product_id          = each.value.product_id != null ? azurerm_api_management_product.products[each.value.product_id].id : null
  api_id              = each.value.api_name != null ? azurerm_api_management_api.apis[each.value.api_name].id : null
  state               = each.value.state
  allow_tracing       = each.value.allow_tracing

  depends_on = [
    azurerm_api_management_product.products,
    azurerm_api_management_api.apis,
  ]
}

resource "azurerm_api_management_policy" "global" {
  count = var.global_policy_xml != null ? 1 : 0

  api_management_id = azurerm_api_management.apim.id
  xml_content       = var.global_policy_xml
}

resource "azurerm_api_management_product_policy" "product_policies" {
  for_each = { for p in var.products : p.product_id => p if p.policy_xml != null }

  product_id          = each.key
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  xml_content         = each.value.policy_xml

  depends_on = [azurerm_api_management_product.products]
}

resource "azurerm_api_management_api_policy" "api_policies" {
  for_each = { for api in var.apis : api.name => api if api.policy_xml != null }

  api_name            = each.key
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  xml_content         = each.value.policy_xml

  depends_on = [azurerm_api_management_api.apis]
}

resource "azurerm_api_management_api_operation_policy" "operation_policies" {
  for_each = { for op in local.api_operations : op.key => op if op.policy_xml != null }

  operation_id        = each.value.operation_id
  api_name            = each.value.api_name
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  xml_content         = each.value.policy_xml

  depends_on = [azurerm_api_management_api_operation.operations]
}
