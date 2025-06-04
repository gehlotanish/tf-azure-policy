output "builtin_policy_assignment_ids" {
  value = merge(
    { for k, v in azurerm_management_group_policy_assignment.builtin_mg : k => v.id },
    { for k, v in azurerm_subscription_policy_assignment.builtin_sub : k => v.id }
  )
  description = "Map of built-in policy assignment names to their corresponding resource IDs."
}

output "custom_policy_assignment_ids" {
  value = merge(
    { for k, v in azurerm_management_group_policy_assignment.custom_mg : k => v.id },
    { for k, v in azurerm_subscription_policy_assignment.custom_sub : k => v.id }
  )
  description = "Map of custom policy assignment names to their corresponding resource IDs."
}

output "custom_policy_definition_ids" {
  value = {
    for k, v in azurerm_policy_definition.custom : k => v.id
  }
  description = "Map of custom policy names to their definition resource IDs."
}
