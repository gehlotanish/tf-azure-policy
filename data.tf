data "azurerm_subscriptions" "available" {}

data "azurerm_management_group" "mg" {
  for_each = toset(local.mg_names)
  name     = each.key
}


data "azurerm_policy_definition" "builtin" {
  for_each     = var.builtin_policies
  display_name = each.value.policy_name
}