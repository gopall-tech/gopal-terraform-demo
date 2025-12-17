resource "azurerm_service_plan" "ui_plan" {
  for_each = var.environments

  name                = "${var.prefix}-${each.key}-ui-plan"
  resource_group_name = azurerm_resource_group.rg[each.key].name
  location            = azurerm_resource_group.rg[each.key].location
  os_type             = "Linux"
  sku_name            = var.ui_plan_sku_name

  tags = merge(var.tags, { env = each.key })
}

resource "azurerm_linux_web_app" "ui_app" {
  for_each = var.environments

  # needs global uniqueness -> suffix
  name                = "${var.prefix}-${each.key}-ui-${random_string.suffix[each.key].result}"
  resource_group_name = azurerm_resource_group.rg[each.key].name
  location            = azurerm_resource_group.rg[each.key].location
  service_plan_id     = azurerm_service_plan.ui_plan[each.key].id

  site_config {
    always_on = false

    application_stack {
      node_version = "18-lts"
    }
  }

  # UI pipeline sets container image; prevent terraform drift fights
  lifecycle {
    ignore_changes = [
      site_config,
      app_settings
    ]
  }

  tags = merge(var.tags, { env = each.key })
}
