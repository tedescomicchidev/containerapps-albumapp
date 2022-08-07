data "azurerm_subscription" "current" {}

locals {
  tags = {
    managed-by  = "terraform"
    environment = var.environment
  }
}

// Resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.tags
}