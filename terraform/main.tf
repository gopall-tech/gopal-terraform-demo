terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-resources-rg"
  location = var.location
}

# --- 1. UI: Azure App Service ---
resource "azurerm_service_plan" "ui_plan" {
  name                = "${var.prefix}-ui-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "ui_app" {
  # Result: Gopal-frontend-ui
  name                = "${var.prefix}-frontend-ui"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.ui_plan.id
  
  site_config {
    application_stack {
      node_version = "18-lts"
    }
  }
}

# --- 2. Gateway: API Management (APIM) ---
resource "azurerm_api_management" "apim" {
  # Result: Gopal-apim
  name                = "${var.prefix}-apim"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = "${var.prefix} Company"
  publisher_email     = "admin@gopalcompany.com"
  sku_name            = "Developer_1"
}

# --- 3. Backend: AKS (API) + ACR ---
resource "azurerm_container_registry" "acr" {
  # ACR does not allow hyphens. This removes them.
  # Result: gopalacr
  name                = lower(replace("${var.prefix}acr", "-", ""))
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = true
}

resource "azurerm_kubernetes_cluster" "aks" {
  # Result: Gopal-aks
  name                = "${var.prefix}-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${lower(var.prefix)}aks"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

# --- 4. Database: Azure SQL ---
resource "azurerm_mssql_server" "sql_server" {
  # Result: Gopal-sql-server
  name                         = lower("${var.prefix}-sql-server")
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_mssql_database" "db" {
  name      = "${var.prefix}-db"
  server_id = azurerm_mssql_server.sql_server.id
  sku_name  = "S0"
}