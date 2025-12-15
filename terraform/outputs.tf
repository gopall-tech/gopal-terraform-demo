output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "ui_web_app_name" {
  value = azurerm_linux_web_app.ui_app.name
}

output "ui_web_app_url" {
  value = "https://${azurerm_linux_web_app.ui_app.default_hostname}"
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "sql_server_fqdn" {
  value = azurerm_mssql_server.sql_server.fully_qualified_domain_name
}