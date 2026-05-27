data "azurerm_resource_group" "testrg" {
  name = "rg-fs-tf-modules-test"
}

resource "random_string" "random" {
  length  = 5
  special = false
  upper   = false
}

module "apim" {
  source = "../"

  name                = "${local.name}-${random_string.random.result}"
  location            = data.azurerm_resource_group.testrg.location
  resource_group_name = data.azurerm_resource_group.testrg.name
  publisher_name      = "Test Publisher"
  publisher_email     = "admin@example.com"
  sku_name            = "Developer_1"
  tags                = local.tags

  global_policy_xml = <<-XML
    <policies>
      <inbound>
        <rate-limit calls="500" renewal-period="60" />
        <set-header name="X-Forwarded-For" exists-action="override">
          <value>@(context.Request.IpAddress)</value>
        </set-header>
      </inbound>
      <backend>
        <forward-request />
      </backend>
      <outbound />
      <on-error />
    </policies>
  XML

  apis = [
    {
      name         = "orders-api"
      revision     = "1"
      display_name = "Orders API"
      path         = "orders"
      protocols    = ["https"]
      service_url  = "https://backend.example.com/orders"

      policy_xml = <<-XML
        <policies>
          <inbound>
            <cors>
              <allowed-origins>
                <origin>https://app.example.com</origin>
              </allowed-origins>
              <allowed-methods>
                <method>GET</method>
                <method>POST</method>
              </allowed-methods>
            </cors>
          </inbound>
          <backend>
            <forward-request />
          </backend>
          <outbound />
          <on-error />
        </policies>
      XML

      operations = [
        {
          operation_id = "list-orders"
          display_name = "List Orders"
          method       = "GET"
          url_template = "/orders"
          description  = "Returns a paginated list of orders."
        },
        {
          operation_id = "create-order"
          display_name = "Create Order"
          method       = "POST"
          url_template = "/orders"
          description  = "Submits a new order."

          policy_xml = <<-XML
            <policies>
              <inbound>
                <validate-jwt header-name="Authorization" failed-validation-httpcode="401">
                  <issuer-signing-keys>
                    <key>{{jwt-signing-key}}</key>
                  </issuer-signing-keys>
                </validate-jwt>
              </inbound>
              <backend>
                <forward-request />
              </backend>
              <outbound />
              <on-error />
            </policies>
          XML
        },
        {
          operation_id = "get-order"
          display_name = "Get Order"
          method       = "GET"
          url_template = "/orders/{orderId}"
          description  = "Returns a single order by ID."
        }
      ]
    },
    {
      name         = "products-api"
      revision     = "1"
      display_name = "Products API"
      path         = "products"
      protocols    = ["https"]
      service_url  = "https://backend.example.com/products"

      operations = [
        {
          operation_id = "list-products"
          display_name = "List Products"
          method       = "GET"
          url_template = "/products"
        },
        {
          operation_id = "get-product"
          display_name = "Get Product"
          method       = "GET"
          url_template = "/products/{productId}"
        }
      ]
    }
  ]

  products = [
    {
      product_id            = "standard-tier"
      display_name          = "Standard Tier"
      published             = true
      subscription_required = true
      approval_required     = false
      subscriptions_limit   = 20
      description           = "Access to all public APIs."
      api_names             = ["orders-api", "products-api"]

      policy_xml = <<-XML
        <policies>
          <inbound>
            <quota calls="10000" renewal-period="3600" />
          </inbound>
          <backend>
            <forward-request />
          </backend>
          <outbound />
          <on-error />
        </policies>
      XML
    },
    {
      product_id            = "internal-tier"
      display_name          = "Internal Tier"
      published             = false
      subscription_required = true
      approval_required     = true
      description           = "Unrestricted access for internal consumers."
      api_names             = ["orders-api", "products-api"]
    }
  ]

  subscriptions = [
    {
      display_name  = "Partner Subscription"
      product_id    = "standard-tier"
      state         = "active"
      allow_tracing = false
    },
    {
      display_name  = "Internal Direct Access"
      api_name      = "orders-api"
      state         = "active"
      allow_tracing = true
    }
  ]
}
