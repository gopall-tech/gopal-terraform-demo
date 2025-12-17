resource "azurerm_api_management" "apim" {
  for_each = var.environments

  name                = "${lower(var.prefix)}-${each.key}-apim"
  location            = azurerm_resource_group.rg[each.key].location
  resource_group_name = azurerm_resource_group.rg[each.key].name
  publisher_name      = "Gopal Corp"
  publisher_email     = "gopal@example.com"
  sku_name            = "Developer_1"
}