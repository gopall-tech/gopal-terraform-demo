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
    node_count = var.aks_node_count

    # IMPORTANT:
    # Your error is "Insufficient vcpu quota ... for family standardBSFamily (B-series) in westus2".
    # So do NOT use Standard_B2s. Use a different family (e.g., DSv2/Dsv3) that typically has quota.
    vm_size = var.aks_vm_size

    # Avoid extra "surge" nodes during upgrades (helps with tight quotas)
    upgrade_settings {
      max_surge = "0%"
    }
  }

  identity {
    type = "SystemAssigned"
  }
}
