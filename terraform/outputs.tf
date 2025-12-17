output "resource_groups" {
  value = { for k, v in azurerm_resource_group.rg : k => v.name }
}

output "aks_clusters" {
  value = { for k, v in azurerm_kubernetes_cluster.aks : k => v.name }
}

output "postgres_fqdns" {
  value = { for k, v in azurerm_postgresql_flexible_server.postgres : k => v.fqdn }
}

output "apim_names" {
  value = { for k, v in azurerm_api_management.apim : k => v.name }
}

output "apim_gateway_urls" {
  value = { for k, v in azurerm_api_management.apim : k => v.gateway_url }
}

output "ui_webapp_names" {
  value = { for k, v in azurerm_linux_web_app.ui_app : k => v.name }
}

output "ui_urls" {
  value = { for k, v in azurerm_linux_web_app.ui_app : k => "https://${v.default_hostname}" }
}
