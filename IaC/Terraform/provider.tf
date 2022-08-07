terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.17.0"
    }

    azapi = {
      source  = "Azure/azapi"
      version = "0.4.0"
    }
  }

  experiments = [module_variable_optional_attrs]
}

provider "azurerm" {
  features {}
}