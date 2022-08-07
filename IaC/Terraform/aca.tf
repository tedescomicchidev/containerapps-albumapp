resource "azapi_resource" "managed_environment" {
  name      = var.managed_environment_name
  location  = azurerm_resource_group.rg.location
  parent_id = azurerm_resource_group.rg.id
  type      = "Microsoft.App/managedEnvironments@2022-03-01"
  tags = local.tags

  lifecycle {
    ignore_changes = [
        tags
    ]
  }
}

resource "azapi_resource" "api_container_app" {
  name      = var.api_name
  location  = azurerm_resource_group.rg.location
  parent_id = azurerm_resource_group.rg.id
  type      = "Microsoft.App/containerApps@2022-03-01"
  tags      = local.tags
  body = jsonencode({
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
  name      = var.ui_name
  location  = azurerm_resource_group.rg.location
  parent_id = azurerm_resource_group.rg.id
  type      = "Microsoft.App/containerApps@2022-03-01"
  tags      = local.tags
  body = jsonencode({
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
            image = "${azurerm_container_registry.aca-registry.login_server}/${var.ui_name}:latest"
            name  = var.ui_name
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

