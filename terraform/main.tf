# 0. Random Suffix (Needed for global uniqueness in APIM, DB, App Service)
resource "random_string" "suffix" {
  for_each = var.environments

  length  = 6
  special = false
  upper   = false
}

# 1. Create Three Resource Groups
resource "azurerm_resource_group" "rg" {
  for_each = var.environments

  name     = "${var.prefix}-${each.key}-rg"
  location = var.location
  tags     = merge(var.tags, { env = each.key })
}

# 2. Create Three AKS Clusters
resource "azurerm_kubernetes_cluster" "aks" {
  for_each = var.environments

  name                = "${var.prefix}-${each.key}-aks"
  location            = azurerm_resource_group.rg[each.key].location
  resource_group_name = azurerm_resource_group.rg[each.key].name
  dns_prefix          = "${lower(var.prefix)}-${each.key}"

  default_node_pool {
    name       = "default"
    node_count = var.aks_node_count
    vm_size    = var.aks_vm_size

    # Avoid extra "surge" nodes during upgrades (helps with tight quotas)
    upgrade_settings {
      max_surge = "0%"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = merge(var.tags, { env = each.key })
}