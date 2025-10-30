resource "azurerm_policy_definition" "custom_mg" {
  for_each = {
    for k, v in var.custom_policies :
    k => v if v.scope_type == "management_group"
  }

  name                = each.value.name
  policy_type         = "Custom"
  mode                = each.value.mode
  display_name        = each.value.display_name
  description         = each.value.description
  policy_rule         = each.value.policy_rule
  metadata            = each.value.metadata
  parameters          = try(each.value.parameters, null)
  management_group_id = data.azurerm_management_group.mg[each.value.scope_name].id
}

resource "azurerm_policy_definition" "custom_sub" {
  for_each = {
    for k, v in var.custom_policies :
    k => v if v.scope_type == "subscription"
  }

  name         = each.value.name
  policy_type  = "Custom"
  mode         = each.value.mode
  display_name = each.value.display_name
  description  = each.value.description
  policy_rule  = each.value.policy_rule
  metadata     = each.value.metadata
  parameters   = try(each.value.parameters, null)
}


resource "azurerm_management_group_policy_assignment" "custom_mg" {
  for_each = {
    for k, v in var.custom_policies :
    k => v if v.scope_type == "management_group"
  }

  name                 = each.value.assignment_name
  policy_definition_id = azurerm_policy_definition.custom_mg[each.key].id
  management_group_id  = data.azurerm_management_group.mg[each.value.scope_name].id
  display_name         = each.value.display_name
  description          = each.value.description
  parameters           = try(each.value.assignment_parameters, null)
  not_scopes           = try(each.value.not_scopes, null)
  location             = each.value.identity_type == null ? null : coalesce(try(each.value.location, null), var.default_identity_location)
  dynamic "identity" {
    for_each = each.value.identity_type == null ? [] : [1]
    content {
      type         = each.value.identity_type
      identity_ids = each.value.identity_type == "UserAssigned" ? try(each.value.identity_ids, null) : null
    }
  }
  non_compliance_message {
    content = each.value.non_compliance_message
  }
}

resource "azurerm_subscription_policy_assignment" "custom_sub" {
  for_each = {
    for k, v in var.custom_policies :
    k => v if v.scope_type == "subscription"
  }

  name                 = each.value.assignment_name
  policy_definition_id = azurerm_policy_definition.custom_sub[each.key].id
  subscription_id      = local.subscriptions[each.value.scope_name]
  display_name         = each.value.display_name
  description          = each.value.description
  parameters           = try(each.value.assignment_parameters, null)
  not_scopes           = try(each.value.not_scopes, null)
  location             = each.value.identity_type == null ? null : coalesce(try(each.value.location, null), var.default_identity_location)
  dynamic "identity" {
    for_each = each.value.identity_type == null ? [] : [1]
    content {
      type         = each.value.identity_type
      identity_ids = each.value.identity_type == "UserAssigned" ? try(each.value.identity_ids, null) : null
    }
  }
  non_compliance_message {
    content = each.value.non_compliance_message
  }
}

resource "azurerm_management_group_policy_assignment" "builtin_mg" {
  for_each = {
    for k, v in var.builtin_policies :
    k => v if v.scope_type == "management_group"
  }

  name                 = each.value.assignment_name
  policy_definition_id = data.azurerm_policy_definition.builtin[each.key].id
  management_group_id  = data.azurerm_management_group.mg[each.value.scope_name].id
  display_name         = each.value.display_name
  description          = each.value.description
  parameters           = try(each.value.assignment_parameters, null)
  not_scopes           = try(each.value.not_scopes, null)
  location             = each.value.identity_type == null ? null : coalesce(try(each.value.location, null), var.default_identity_location)
  dynamic "identity" {
    for_each = each.value.identity_type == null ? [] : [1]
    content {
      type         = each.value.identity_type
      identity_ids = each.value.identity_type == "UserAssigned" ? try(each.value.identity_ids, null) : null
    }
  }
  non_compliance_message {
    content = each.value.non_compliance_message
  }
}

resource "azurerm_subscription_policy_assignment" "builtin_sub" {
  for_each = {
    for k, v in var.builtin_policies :
    k => v if v.scope_type == "subscription"
  }

  name                 = each.value.assignment_name
  policy_definition_id = data.azurerm_policy_definition.builtin[each.key].id
  subscription_id      = local.subscriptions[each.value.scope_name]
  display_name         = each.value.display_name
  description          = each.value.description
  parameters           = try(each.value.assignment_parameters, null)
  not_scopes           = try(each.value.not_scopes, null)
  location             = each.value.identity_type == null ? null : coalesce(try(each.value.location, null), var.default_identity_location)
  dynamic "identity" {
    for_each = each.value.identity_type == null ? [] : [1]
    content {
      type         = each.value.identity_type
      identity_ids = each.value.identity_type == "UserAssigned" ? try(each.value.identity_ids, null) : null
    }
  }
  non_compliance_message {
    content = each.value.non_compliance_message
  }
}

# Policy Initiative Definitions
resource "azurerm_policy_set_definition" "custom_mg" {
  for_each = {
    for k, v in var.policy_initiatives :
    k => v if v.scope_type == "management_group"
  }

  name                = each.value.name
  policy_type         = each.value.policy_type
  display_name        = each.value.display_name
  description         = each.value.description
  parameters          = try(each.value.parameters, null)
  management_group_id = data.azurerm_management_group.mg[each.value.scope_name].id

  dynamic "policy_definition_reference" {
    for_each = each.value.policy_definitions
    content {
      version              = try(policy_definition_reference.value.version, null)
      policy_definition_id = policy_definition_reference.value.policy_definition_id
      parameter_values     = try(policy_definition_reference.value.parameter_values, null)
    }
  }
}

resource "azurerm_policy_set_definition" "custom_sub" {
  for_each = {
    for k, v in var.policy_initiatives :
    k => v if v.scope_type == "subscription"
  }

  name         = each.value.name
  policy_type  = each.value.policy_type
  display_name = each.value.display_name
  description  = each.value.description
  parameters   = try(each.value.parameters, null)

  dynamic "policy_definition_reference" {
    for_each = each.value.policy_definitions
    content {
      version              = try(policy_definition_reference.value.version, null)
      policy_definition_id = policy_definition_reference.value.policy_definition_id
      parameter_values     = try(policy_definition_reference.value.parameter_values, null)
    }
  }
}

# Policy Initiative Assignments
resource "azurerm_management_group_policy_assignment" "initiative_mg" {
  for_each = {
    for k, v in var.policy_initiatives :
    k => v if v.scope_type == "management_group"
  }

  name                 = each.value.assignment_name
  policy_definition_id = azurerm_policy_set_definition.custom_mg[each.key].id
  management_group_id  = data.azurerm_management_group.mg[each.value.scope_name].id
  display_name         = each.value.display_name
  description          = each.value.description
  parameters           = try(each.value.assignment_parameters, null)
  not_scopes           = try(each.value.not_scopes, null)
  location             = each.value.identity_type == null ? null : coalesce(try(each.value.location, null), var.default_identity_location)
  dynamic "identity" {
    for_each = each.value.identity_type == null ? [] : [1]
    content {
      type         = each.value.identity_type
      identity_ids = each.value.identity_type == "UserAssigned" ? try(each.value.identity_ids, null) : null
    }
  }
  non_compliance_message {
    content = each.value.non_compliance_message
  }
}

resource "azurerm_subscription_policy_assignment" "initiative_sub" {
  for_each = {
    for k, v in var.policy_initiatives :
    k => v if v.scope_type == "subscription"
  }

  name                 = each.value.assignment_name
  policy_definition_id = azurerm_policy_set_definition.custom_sub[each.key].id
  subscription_id      = local.subscriptions[each.value.scope_name]
  display_name         = each.value.display_name
  description          = each.value.description
  parameters           = try(each.value.assignment_parameters, null)
  not_scopes           = try(each.value.not_scopes, null)
  location             = each.value.identity_type == null ? null : coalesce(try(each.value.location, null), var.default_identity_location)
  dynamic "identity" {
    for_each = each.value.identity_type == null ? [] : [1]
    content {
      type         = each.value.identity_type
      identity_ids = each.value.identity_type == "UserAssigned" ? try(each.value.identity_ids, null) : null
    }
  }
  non_compliance_message {
    content = each.value.non_compliance_message
  }
}