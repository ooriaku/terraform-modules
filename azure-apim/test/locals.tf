locals {
  name = lower("apim-test")
  tags = {
    App             = "Vantage"
    Owner           = "IT"
    Confidentiality = "Internal"
    CostCenter      = "CentralIT"
    Dept            = "IT"
    Env             = "Dev"
    BusinessImpact  = "Low"
  }
}
