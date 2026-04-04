locals {
  name         = lower("env-test")
  name_no_dash = replace(local.name, "-", "")
  tags = {
    environment = "dev"
  }
}