resource "azurerm_postgresql_flexible_server" "postgres" {
  for_each = var.environments

  # needs global uniqueness -> suffix
  name                = "${var.prefix}-${each.key}-psql-${random_string.suffix[each.key].result}"
  resource_group_name = azurerm_resource_group.rg[each.key].name
  location            = azurerm_resource_group.rg[each.key].location

  version                = "13"
  administrator_login    = var.postgres_admin_user
  administrator_password = var.postgres_admin_password

  sku_name   = "B_Standard_B1ms"
  storage_mb = 32768

  tags = merge(var.tags, { env = each.key })
}

resource "azurerm_postgresql_flexible_server_database" "db" {
  for_each = var.environments

  name      = "appdb"
  server_id = azurerm_postgresql_flexible_server.postgres[each.key].id
  collation = "en_US.utf8"
  charset   = "utf8"
}

# Demo-friendly (keeps it simple for class): open public firewall.
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_all" {
  for_each = var.environments

  name             = "allow-all"
  server_id        = azurerm_postgresql_flexible_server.postgres[each.key].id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}
