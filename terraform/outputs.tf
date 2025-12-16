output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "postgres_server_fqdn" {
  value = azurerm_postgresql_flexible_server.postgres.fqdn
}

output "postgres_db_name" {
  value = azurerm_postgresql_flexible_server_database.db.name
}