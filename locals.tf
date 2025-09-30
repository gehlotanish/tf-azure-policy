locals {
  subscriptions = {
    for s in data.azurerm_subscriptions.available.subscriptions :
    s.display_name => s.subscription_id
  }
}

locals {
  mg_names = distinct([
    for v in merge(var.builtin_policies, var.custom_policies, var.policy_initiatives) :
    v.scope_name if v.scope_type == "management_group"
  ])
}