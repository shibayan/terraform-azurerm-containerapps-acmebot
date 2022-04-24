provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = "~> 3.0"
  }
}

data "azurerm_client_config" "current" {
}

resource "azurerm_resource_group" "default" {
  name     = "rg-acmebot-module"
  location = "westus2"
}

module "containerapps_acmebot" {
  source  = "shibayan/containerapps-acmebot/azurerm"
  version = "~> 1.0"

  function_app_name     = "func-acmebot-module"
  app_service_plan_name = "plan-acmebot-module"
  storage_account_name  = "stacmebotmodule"
  app_insights_name     = "appi-acmebot-module"
  workspace_name        = "log-acmebot-module"
  resource_group_name   = azurerm_resource_group.default.name
  location              = azurerm_resource_group.default.location
  mail_address          = "YOUR-EMAIL-ADDRESS"
  subscription_id       = data.azurerm_client_config.current.subscription_id
}

output "principal_id" {
  value = module.containerapps_acmebot.principal_id
}