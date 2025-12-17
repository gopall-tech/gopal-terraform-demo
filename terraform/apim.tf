resource "azurerm_api_management" "apim" {
  for_each = var.environments

  # needs global uniqueness -> suffix
  name                = "${var.prefix}-${each.key}-apim-${random_string.suffix[each.key].result}"
  location            = azurerm_resource_group.rg[each.key].location
  resource_group_name = azurerm_resource_group.rg[each.key].name

  publisher_name  = var.apim_publisher_name
  publisher_email = var.apim_publisher_email

  # cheaper tier
  sku_name = var.apim_sku_name

  tags = merge(var.tags, { env = each.key })
}
