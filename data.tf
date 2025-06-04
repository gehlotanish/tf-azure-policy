data "azurerm_subscriptions" "available" {}

data "azurerm_management_group" "mg" {
  for_each = {
    for k, v in merge(var.builtin_policies, var.custom_policies) :
    v.scope_name => v if v.scope_type == "management_group"
  }

  name = each.key
}

data "azurerm_policy_definition" "builtin" {
  for_each = var.builtin_policies
  name     = each.key
}