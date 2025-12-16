terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "gopalstate123"  # Matches your storage account
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# --- Resource Group ---
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
  # DOWNGRADED: P1v2 (Premium) -> B1 (Basic) to fit quota
  sku_name            = "B1" 
}

resource "azurerm_linux_web_app" "ui_app" {
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
  name                = "${var.prefix}-apim"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = "${var.prefix} Company"
  publisher_email     = "admin@gopalcompany.com"
  # Consumption tier is faster/cheaper, but Developer is fine if you have quota.
  # If this fails next, we will switch to "Consumption".
  sku_name            = "Developer_1" 
}

# --- 3. Backend: AKS (API) + ACR ---
resource "azurerm_container_registry" "acr" {
  name                = lower(replace("${var.prefix}acr", "-", ""))
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = true
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${lower(var.prefix)}aks"

  default_node_pool {
    name       = "default"
    # DOWNGRADED: 2 Nodes -> 1 Node (Saves vCPU quota)
    node_count = 1 
    # DOWNGRADED: DS2_v2 -> B2s (Cheaper/Smaller)
    vm_size    = "Standard_B2s" 
  }

  identity {
    type = "SystemAssigned"
  }
}

# --- 4. Database: Azure SQL ---
resource "azurerm_mssql_server" "sql_server" {
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