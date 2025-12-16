resource "azurerm_api_management" "apim" {
  # Name must be globally unique!
  name                = "${lower(var.prefix)}-apim-service-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = "Gopal Corp"
  publisher_email     = "gopal@example.com"
  sku_name            = "Developer_1"
}

# --- API Configuration for Backend A ---
resource "azurerm_api_management_api" "api_a" {
  name                = "backend-a-api"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.apim.name
  revision            = "1"
  display_name        = "Backend A API"
  path                = "a" # This sets the URL to /a
  protocols           = ["http", "https"]

  # Wired to your Backend A IP
  service_url = "http://52.255.224.214"

  # Disables the security key requirement for easy browser testing
  subscription_required = false
}

# This adds a "GET /" operation so you can actually test it in a browser
resource "azurerm_api_management_api_operation" "get_a" {
  operation_id        = "get-backend-a"
  api_name            = azurerm_api_management_api.api_a.name
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = azurerm_resource_group.rg.name
  display_name        = "Get Data from A"
  method              = "GET"
  url_template        = "/"
  description         = "Forwards request to Backend A"
  response {
    status_code = 200
  }
}

# --- API Configuration for Backend B ---
resource "azurerm_api_management_api" "api_b" {
  name                = "backend-b-api"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.apim.name
  revision            = "1"
  display_name        = "Backend B API"
  path                = "b" # This sets the URL to /b
  protocols           = ["http", "https"]

  # Wired to your Backend B IP
  service_url = "http://48.216.195.86"

  # Disables the security key requirement for easy browser testing
  subscription_required = false
}

# This adds a "GET /" operation so you can actually test it in a browser
resource "azurerm_api_management_api_operation" "get_b" {
  operation_id        = "get-backend-b"
  api_name            = azurerm_api_management_api.api_b.name
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = azurerm_resource_group.rg.name
  display_name        = "Get Data from B"
  method              = "GET"
  url_template        = "/"
  description         = "Forwards request to Backend B"
  response {
    status_code = 200
  }
}