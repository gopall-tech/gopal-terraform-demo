resource "azurerm_service_plan" "ui_plan" {
  for_each = var.environments

  name                = "${var.prefix}-${each.key}-ui-plan"
  resource_group_name = azurerm_resource_group.rg[each.key].name
  location            = azurerm_resource_group.rg[each.key].location
  os_type             = "Linux"
  sku_name            = "F1" # Free Tier
}

resource "azurerm_linux_web_app" "ui_app" {
  for_each = var.environments

  name                = "${lower(var.prefix)}-${each.key}-ui-app"
  resource_group_name = azurerm_resource_group.rg[each.key].name
  location            = azurerm_resource_group.rg[each.key].location
  service_plan_id     = azurerm_service_plan.ui_plan[each.key].id

  site_config {
    # CRITICAL FIX: Must be false for F1 (Free) Tier
    always_on = false 
    
    application_stack {
      node_version = "18-lts"
    }
  }
}