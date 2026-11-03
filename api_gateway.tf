resource "azurerm_api_management" "main" {
  name                = var.api_gateway_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  publisher_name      = "FIAP"
  publisher_email     = var.publisher_email
  sku_name            = "Consumption_0"
}

resource "azurerm_api_management_api" "main" {
  name                = "siaes-api"
  resource_group_name = azurerm_resource_group.main.name
  api_management_name = azurerm_api_management.main.name
  revision            = "1"
  display_name        = "SIAES API"
  path                = "api"
  protocols           = ["https"]
  service_url         = "https://${azurerm_kubernetes_cluster.main.fqdn}"
}

resource "azurerm_api_management_api_operation" "health" {
  operation_id        = "health"
  api_name            = azurerm_api_management_api.main.name
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name
  display_name        = "Health"
  method              = "GET"
  url_template        = "/health"
  response {
    status_code = 200
  }
}
