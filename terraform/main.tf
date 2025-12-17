# 1. Create Three Resource Groups
resource "azurerm_resource_group" "rg" {
  for_each = var.environments

  name     = "${var.prefix}-${each.key}-resources"
  location = var.location
}

# 2. Create Three AKS Clusters
resource "azurerm_kubernetes_cluster" "aks" {
  for_each = var.environments

  name                = "${var.prefix}-${each.key}-aks"
  location            = azurerm_resource_group.rg[each.key].location
  resource_group_name = azurerm_resource_group.rg[each.key].name
  dns_prefix          = "${lower(var.prefix)}-${each.key}-aks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }
}