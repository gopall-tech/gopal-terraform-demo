terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "gopalstate123"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# --- Resource Group (Environment Specific) ---
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-${var.environment}-rg"
  location = var.location
}

# --- 1. API Management (Consumption Tier) ---
resource "azurerm_api_management" "apim" {
  name                = "${var.prefix}-${var.environment}-apim"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = "${var.prefix} Company"
  publisher_email     = "admin@gopalcompany.com"
  sku_name            = "Consumption_0"
}

# --- 2. AKS + ACR ---
resource "azurerm_container_registry" "acr" {
  name                = lower(replace("${var.prefix}${var.environment}acr", "-", ""))
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = true
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-${var.environment}-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${lower(var.prefix)}${var.environment}aks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }
}

# --- 3. Database: PostgreSQL (Replaces MSSQL) ---
resource "azurerm_postgresql_flexible_server" "postgres" {
  name                   = lower("${var.prefix}-${var.environment}-psql")
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  version                = "13"
  administrator_login    = var.sql_admin_username
  administrator_password = var.sql_admin_password
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms"
  
  # Allow public access for simplicity (Student/Demo)
  # In Prod, we would use VNET integration
}

resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = "${var.prefix}-db"
  server_id = azurerm_postgresql_flexible_server.postgres.id
  collation = "en_US.utf8"
  charset   = "utf8"
}

# Allow Azure Services to access the DB
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure" {
  name             = "allow-azure-services"
  server_id        = azurerm_postgresql_flexible_server.postgres.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}