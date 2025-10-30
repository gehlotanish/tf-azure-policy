variable "builtin_policies" {
  description = <<DESC
Map of built-in policy assignments to apply at either the subscription or management group level.

Key: Built-in policy definition name.

Each object must include:
- policy_name: The actual name of the policy definition in Azure.
- assignment_name: Unique name for the policy assignment.
- scope_type: "subscription" or "management_group".
- scope_name: The display name of the target scope (as shown in the Azure Portal).
- display_name: Friendly display name for the policy assignment.
- description: Description of the policy assignment.
- parameters: Optional parameters for the policy definition (can be `null`).
- non_compliance_message: Message to display when the policy is non-compliant.
DESC

  type = map(object({
    policy_name            = string
    assignment_name        = string
    scope_type             = string
    scope_name             = string
    display_name           = string
    description            = string
    parameters             = optional(any)
    assignment_parameters  = optional(any)
    non_compliance_message = string
    identity_type          = optional(string)
    identity_ids           = optional(list(string))
    not_scopes             = optional(list(string))
    location               = optional(string)
  }))

  default = {}
}

variable "custom_policies" {
  description = <<DESC
Map of custom policy definitions and their assignments.

Key: Custom policy definition name.

Each object must include:
- name: The actual name of the policy definition in Azure.
- mode: "All", "Indexed", or another supported Azure policy mode.
- assignment_name: Unique name for the policy assignment.
- scope_type: "subscription" or "management_group".
- scope_name: The display name of the target scope (as shown in the Azure Portal).
- display_name: Friendly display name for the policy assignment.
- description: Description of the policy assignment.
- policy_rule: JSON-encoded string representing the policy rule.
- metadata: JSON-encoded string representing policy metadata.
- parameters: Optional parameters for the policy definition (can be `null`).
- non_compliance_message: Message to display when the policy is non-compliant.
DESC

  type = map(object({
    name                   = string
    mode                   = string
    assignment_name        = string
    scope_type             = string
    scope_name             = string
    display_name           = string
    description            = string
    policy_rule            = string
    metadata               = string
    parameters             = optional(any)
    assignment_parameters  = optional(any)
    non_compliance_message = string
    identity_type          = optional(string)
    identity_ids           = optional(list(string))
    not_scopes             = optional(list(string))
    location               = optional(string)
  }))
  default = {}
}

variable "policy_initiatives" {
  description = <<DESC
Map of policy initiatives (policy sets) to deploy and assign.

Key: Policy initiative name.

Each object must include:
- name: The actual name of the policy initiative in Azure.
- display_name: Friendly display name for the policy initiative.
- description: Description of the policy initiative.
- policy_type: "Custom" or "BuiltIn".
- assignment_name: Unique name for the policy assignment.
- scope_type: "subscription" or "management_group".
- scope_name: The display name of the target scope (as shown in the Azure Portal).
- parameters: Optional parameters for the policy initiative (can be `null`).
- non_compliance_message: Message to display when the policy is non-compliant.
- policy_definitions: List of policy definitions included in the initiative.
DESC

  type = map(object({
    name                   = string
    display_name           = string
    description            = string
    policy_type            = string
    assignment_name        = string
    scope_type             = string
    scope_name             = string
    parameters             = optional(any)
    assignment_parameters  = optional(any)
    non_compliance_message = string
    identity_type          = optional(string)
    identity_ids           = optional(list(string))
    not_scopes             = optional(list(string))
    location               = optional(string)
    policy_definitions = list(object({
      version              = optional(string)
      policy_definition_id = string
      parameter_values     = optional(any)
    }))
  }))

  default = {}
}

variable "default_identity_location" {
  description = "Default Azure location to use for policy assignments when an identity is assigned and per-assignment location is not provided."
  type        = string
  default     = "westus2"
}
