resource "azapi_resource" "managed_environment" {
  type      = "Microsoft.App/managedEnvironments@2022-03-01"
  name      = var.managed_environment_name
  location  = azurerm_resource_group.rg.location
  parent_id = azurerm_resource_group.rg.id
  body = jsonencode({
    properties = {
      appLogsConfiguration = {
        destination = "log-analytics"
        logAnalyticsConfiguration = {
          customerId = azurerm_log_analytics_workspace.acaworkspace.workspace_id
          sharedKey  = azurerm_log_analytics_workspace.acaworkspace.primary_shared_key
        }
      }
    }
  })  
  tags = local.tags

  lifecycle {
    ignore_changes = [
        tags
    ]
  }
}

resource "azapi_resource" "api_container_app" {
  type      = "Microsoft.App/containerApps@2022-03-01"
  name      = var.api_name
  location  = azurerm_resource_group.rg.location
  parent_id = azurerm_resource_group.rg.id
  tags      = local.tags
  
  body = jsonencode({
    identity = {
      type = "SystemAssigned"
    }
    properties = {
      managedEnvironmentId = azapi_resource.managed_environment.id
      configuration = {
        ingress = {
          targetPort = 3500
          external   = true
        },
        registries = [
          {
            server            = azurerm_container_registry.aca-registry.login_server
            username          = azurerm_container_registry.aca-registry.admin_username
            passwordSecretRef = "registry-password"
          }
        ],
        secrets : [
          {
            name = "registry-password"
            # Todo: Container apps does not yet support Managed Identity connection to ACR
            value = azurerm_container_registry.aca-registry.admin_password
          }
        ]
      },
      template = {
        containers = [
          {
            image = "${azurerm_container_registry.aca-registry.login_server}/${var.api_name}:latest"
            name  = var.api_name
          }
        ]
      }
    }
  })

  lifecycle {
    ignore_changes = [
        tags
    ]
  }

  # This seems to be important for the private registry to work(?)
  ignore_missing_property = true
  response_export_values = ["properties.configuration.ingress"]
}



resource "azapi_resource" "ui_container_app" {
  type      = "Microsoft.App/containerApps@2022-03-01"
  name      = var.ui_name
  location  = azurerm_resource_group.rg.location
  parent_id = azurerm_resource_group.rg.id
  tags      = local.tags
  body = jsonencode({
    properties = {
      managedEnvironmentId = azapi_resource.managed_environment.id
      configuration = {
        ingress = {
          targetPort = 3000
          external   = true
        },
        registries = [
          {
            server            = azurerm_container_registry.aca-registry.login_server
            username          = azurerm_container_registry.aca-registry.admin_username
            passwordSecretRef = "registry-password"
          }
        ],
        secrets : [
          {
            name = "registry-password"
            # Todo: Container apps does not yet support Managed Identity connection to ACR
            value = azurerm_container_registry.aca-registry.admin_password
          }
        ]
      },
      template = {
        containers = [
          {
            image = "${azurerm_container_registry.aca-registry.login_server}/${var.ui_name}:latest"
            name  = var.ui_name,
            resources = {
              cpu    = 0.25,
              memory = "0.5Gi"
            }
            env : [
              {
                "name" : "APPINSIGHTS_INSTRUMENTATIONKEY",
                "value" : azurerm_application_insights.aca-ai.instrumentation_key
              },
              {
                "name" : "API_BASE_URL",
                "value" : "https://${jsondecode(azapi_resource.api_container_app.output).properties.configuration.ingress.fqdn}"
              }
            ]
          }
        ]
      }
    }
  })

  lifecycle {
    ignore_changes = [
        tags
    ]
  }

  # This seems to be important for the private registry to work(?)
  ignore_missing_property = true
  response_export_values = ["properties.configuration.ingress"]
}

