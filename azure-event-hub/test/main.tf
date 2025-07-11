resource "azurerm_resource_group" "rg" {
  name     = "Event_Hub-Test"
  location = "eastus"
  tags = {
    App             = "Vantage"
    Owner           = "IT"
    Confidentiality = "Sensitive"
    CostCenter      = "CentralIT"
    Dept            = "IT"
    Env             = "Dev"
    BusinessImpact  = "Medium"
  }
}

module "eventhubnamespace" {
  source = "../"

  name                = "ehubnamespace-test92"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku      = "Standard"
  capacity = 2

  auto_inflate = {
    enabled                  = true
    maximum_throughput_units = 5
  }

  tags = {
    App             = "Vantage"
    Owner           = "IT"
    Confidentiality = "Sensitive"
    CostCenter      = "CentralIT"
    Dept            = "IT"
    Env             = "Dev"
    BusinessImpact  = "Medium"
  }

  hubs = [
    {
      name              = "ehub1"
      partitions        = 8
      message_retention = 1
      consumers = [
        "app1",
      "app2"]
      keys = [
        {
          name   = "app1"
          listen = true
          send   = false
        },
        {
          name   = "app2"
          listen = true
          send   = true
        }
      ]
    },

    {
      name              = "ehub2"
      partitions        = 2
      message_retention = 5
      consumers = [
        "app3",
      "app4"]
      keys = [
        {
          name   = "app3"
          listen = true
          send   = false
        },
        {
          name   = "app4"
          listen = true
          send   = true
        }
      ]
    }
  ]
}
