resource "azurerm_postgresql_flexible_server" "postgres" {
  # CHANGED: Added "-2" to the name to avoid conflict with the failed East US resource
  name                   = "${lower(var.prefix)}-db-server-2"
  
  resource_group_name    = azurerm_resource_group.rg.name
  location               = "East US 2" # Keeping this as East US 2
  version                = "13"
  administrator_login    = "gopaladmin"
  administrator_password = "MyComplexPassword123!" 
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms"
  zone                   = "1"
}

resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = "appdb"
  server_id = azurerm_postgresql_flexible_server.postgres.id
  collation = "en_US.utf8"
  charset   = "utf8"
}

# This rule allows "Azure Services" (like your AKS cluster) to access the DB
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure" {
  name             = "allow-azure-services"
  server_id        = azurerm_postgresql_flexible_server.postgres.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}