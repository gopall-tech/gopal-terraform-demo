resource "random_string" "suffix" {
  for_each = var.environments
  length   = 6
  upper    = false
  special  = false
  numeric  = true
}

# Resource Groups (1 per env)
resource "azurerm_resource_group" "rg" {
  for_each = var.environments

  name     = "${var.prefix}-${each.key}-rg"
  location = var.location
  tags     = merge(var.tags, { env = each.key })
}

# AKS (1 per env)
resource "azurerm_kubernetes_cluster" "aks" {
  for_each = var.environments

  name                = "${var.prefix}-${each.key}-aks"
  location            = azurerm_resource_group.rg[each.key].location
  resource_group_name = azurerm_resource_group.rg[each.key].name
  dns_prefix          = "${var.prefix}-${each.key}"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = merge(var.tags, { env = each.key })
}
