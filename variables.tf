variable "builtin_policies" {
  description = <<DESC
Map of built-in policy assignments to apply at either the subscription or management group level.

Key: Built-in policy definition name.

Each object must include:
- assignment_name: Unique name for the policy assignment.
- scope_type: "subscription" or "management_group".
- scope_name: The display name of the target scope (as shown in the Azure Portal).
- display_name: Friendly display name for the policy assignment.
- description: Description of the policy assignment.
DESC

  type = map(object({
    policy_name     = string
    assignment_name = string
    scope_type      = string
    scope_name      = string
    display_name    = string
    description     = string
    parameters      = any
  }))

  default = {}
}

variable "custom_policies" {
  description = <<DESC
Map of custom policy definitions and their assignments.

Key: Custom policy definition name.

Each object must include:
- mode: "All", "Indexed", or another supported Azure policy mode.
- assignment_name: Unique name for the policy assignment.
- scope_type: "subscription" or "management_group".
- scope_name: The display name of the target scope (as shown in the Azure Portal).
- display_name: Friendly display name for the policy assignment.
- description: Description of the policy assignment.
- policy_rule: JSON-encoded string representing the policy rule.
- metadata: JSON-encoded string representing policy metadata.
DESC

  type = map(object({
    mode            = string
    assignment_name = string
    scope_type      = string
    scope_name      = string
    display_name    = string
    description     = string
    policy_rule     = string
    metadata        = string
  }))

  default = {}
}
