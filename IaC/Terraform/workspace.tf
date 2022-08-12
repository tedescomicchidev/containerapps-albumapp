locals {
  workspace_name = "log${var.github_user_name}"
  appinsights_name = "appinsights${var.github_user_name}"
}

# Creates Log Anaylytics Workspace
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace
resource "azurerm_log_analytics_workspace" "acaworkspace" {
  name                = local.workspace_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.tags
}

resource "azurerm_application_insights" "aca-ai" {
  name                = local.appinsights_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  workspace_id        = azurerm_log_analytics_workspace.acaworkspace.id
  application_type    = "web"
  tags                = local.tags
}