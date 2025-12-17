output "aks_clusters" {
  value = { for k, v in azurerm_kubernetes_cluster.aks : k => v.name }
}

output "ui_urls" {
  value = { for k, v in azurerm_linux_web_app.ui_app : k => "https://${v.default_hostname}" }
}

output "apim_urls" {
  value = { for k, v in azurerm_api_management.apim : k => v.gateway_url }
}