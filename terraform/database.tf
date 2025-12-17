resource "azurerm_postgresql_flexible_server" "postgres" {
  for_each = var.environments

  name                   = "${lower(var.prefix)}-${each.key}-db-server"
  resource_group_name    = azurerm_resource_group.rg[each.key].name
  location               = azurerm_resource_group.rg[each.key].location
  version                = "13"
  administrator_login    = "gopaladmin"
  administrator_password = "MyComplexPassword123!" 
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms"
  # zone                   = "1" # Comment out zone if you hit availability errors
}

resource "azurerm_postgresql_flexible_server_database" "db" {
  for_each = var.environments

  name      = "appdb"
  server_id = azurerm_postgresql_flexible_server.postgres[each.key].id
  collation = "en_US.utf8"
  charset   = "utf8"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure" {
  for_each = var.environments

  name             = "allow-azure-services"
  server_id        = azurerm_postgresql_flexible_server.postgres[each.key].id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}