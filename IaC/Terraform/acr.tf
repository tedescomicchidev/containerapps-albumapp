locals {
  container_registry_name = "${var.azure_container_registry_prefix}${var.github_user_name}"
}

// Container registry
resource "azurerm_container_registry" "aca-registry" {
  name                = local.container_registry_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Basic"
  admin_enabled       = true

  tags = local.tags
}
