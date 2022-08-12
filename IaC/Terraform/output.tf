output "resource_group_name" {
    value = azurerm_resource_group.rg.name
}

output "log_analytics" {
  description = "Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.acaworkspace.name
}