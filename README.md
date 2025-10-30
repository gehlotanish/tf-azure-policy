# terraform code for azure policies

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.46.0 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.46.0 |
## Modules

No modules.
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_builtin_policies"></a> [builtin\_policies](#input\_builtin\_policies) | Map of built-in policy assignments to apply at either the subscription or management group level.<br/><br/>Key: Built-in policy definition name.<br/><br/>Each object must include:<br/>- policy\_name: The actual name of the policy definition in Azure.<br/>- assignment\_name: Unique name for the policy assignment.<br/>- scope\_type: "subscription" or "management\_group".<br/>- scope\_name: The display name of the target scope (as shown in the Azure Portal).<br/>- display\_name: Friendly display name for the policy assignment.<br/>- description: Description of the policy assignment.<br/>- parameters: Optional parameters for the policy definition (can be `null`).<br/>- non\_compliance\_message: Message to display when the policy is non-compliant. | <pre>map(object({<br/>    policy_name            = string<br/>    assignment_name        = string<br/>    scope_type             = string<br/>    scope_name             = string<br/>    display_name           = string<br/>    description            = string<br/>    parameters             = optional(any)<br/>    assignment_parameters  = optional(any)<br/>    non_compliance_message = string<br/>    identity_type          = optional(string)<br/>    identity_ids           = optional(list(string))<br/>    not_scopes             = optional(list(string))<br/>    location               = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_custom_policies"></a> [custom\_policies](#input\_custom\_policies) | Map of custom policy definitions and their assignments.<br/><br/>Key: Custom policy definition name.<br/><br/>Each object must include:<br/>- name: The actual name of the policy definition in Azure.<br/>- mode: "All", "Indexed", or another supported Azure policy mode.<br/>- assignment\_name: Unique name for the policy assignment.<br/>- scope\_type: "subscription" or "management\_group".<br/>- scope\_name: The display name of the target scope (as shown in the Azure Portal).<br/>- display\_name: Friendly display name for the policy assignment.<br/>- description: Description of the policy assignment.<br/>- policy\_rule: JSON-encoded string representing the policy rule.<br/>- metadata: JSON-encoded string representing policy metadata.<br/>- parameters: Optional parameters for the policy definition (can be `null`).<br/>- non\_compliance\_message: Message to display when the policy is non-compliant. | <pre>map(object({<br/>    name                   = string<br/>    mode                   = string<br/>    assignment_name        = string<br/>    scope_type             = string<br/>    scope_name             = string<br/>    display_name           = string<br/>    description            = string<br/>    policy_rule            = string<br/>    metadata               = string<br/>    parameters             = optional(any)<br/>    assignment_parameters  = optional(any)<br/>    non_compliance_message = string<br/>    identity_type          = optional(string)<br/>    identity_ids           = optional(list(string))<br/>    not_scopes             = optional(list(string))<br/>    location               = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_default_identity_location"></a> [default\_identity\_location](#input\_default\_identity\_location) | Default Azure location to use for policy assignments when an identity is assigned and per-assignment location is not provided. | `string` | `"westus2"` | no |
| <a name="input_policy_initiatives"></a> [policy\_initiatives](#input\_policy\_initiatives) | Map of policy initiatives (policy sets) to deploy and assign.<br/><br/>Key: Policy initiative name.<br/><br/>Each object must include:<br/>- name: The actual name of the policy initiative in Azure.<br/>- display\_name: Friendly display name for the policy initiative.<br/>- description: Description of the policy initiative.<br/>- policy\_type: "Custom" or "BuiltIn".<br/>- assignment\_name: Unique name for the policy assignment.<br/>- scope\_type: "subscription" or "management\_group".<br/>- scope\_name: The display name of the target scope (as shown in the Azure Portal).<br/>- parameters: Optional parameters for the policy initiative (can be `null`).<br/>- non\_compliance\_message: Message to display when the policy is non-compliant.<br/>- policy\_definitions: List of policy definitions included in the initiative. | <pre>map(object({<br/>    name                   = string<br/>    display_name           = string<br/>    description            = string<br/>    policy_type            = string<br/>    assignment_name        = string<br/>    scope_type             = string<br/>    scope_name             = string<br/>    parameters             = optional(any)<br/>    assignment_parameters  = optional(any)<br/>    non_compliance_message = string<br/>    identity_type          = optional(string)<br/>    identity_ids           = optional(list(string))<br/>    not_scopes             = optional(list(string))<br/>    location               = optional(string)<br/>    policy_definitions = list(object({<br/>      version              = optional(string)<br/>      policy_definition_id = string<br/>      parameter_values     = optional(any)<br/>    }))<br/>  }))</pre> | `{}` | no |  
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_builtin_policy_assignment_ids"></a> [builtin\_policy\_assignment\_ids](#output\_builtin\_policy\_assignment\_ids) | Map of built-in policy assignment names to their corresponding resource IDs. |
| <a name="output_custom_policy_assignment_ids"></a> [custom\_policy\_assignment\_ids](#output\_custom\_policy\_assignment\_ids) | Map of custom policy assignment names to their corresponding resource IDs. |
| <a name="output_custom_policy_definition_ids"></a> [custom\_policy\_definition\_ids](#output\_custom\_policy\_definition\_ids) | Map of custom policy names to their definition resource IDs. |
| <a name="output_policy_initiative_assignment_ids"></a> [policy\_initiative\_assignment\_ids](#output\_policy\_initiative\_assignment\_ids) | Map of policy initiative names to their assignment resource IDs. |
| <a name="output_policy_initiative_definition_ids"></a> [policy\_initiative\_definition\_ids](#output\_policy\_initiative\_definition\_ids) | Map of policy initiative names to their definition resource IDs. |
<!-- END_TF_DOCS -->

## Usage

```tf
custom_policies = {
  deny_public_ip = {
    name                   = "deny-public-ip"
    mode                   = "All"
    assignment_name        = "deny-public-ip-assignment"
    scope_type             = "management_group"
    scope_name             = "mg-platform"
    display_name           = "Deny Public IP"
    description            = "Denies creation of public IP addresses."
    policy_rule            = file("${path.module}/policies/deny_public_ip.json")
    metadata               = file("${path.module}/policies/deny_public_ip.metadata.json")
    parameters             = jsonencode({})
    non_compliance_message = "Creation of public IP addresses is not allowed."
    # Optional: assign identity to the policy assignment
    # identity_type = "SystemAssigned"
    # or for user-assigned identity
    # identity_type = "UserAssigned"
    # identity_ids  = ["/subscriptions/<subId>/resourceGroups/<rg>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<uaiName>"]
    # Optional: exclude scopes from assignment evaluation
    # not_scopes = [
    #   "/subscriptions/<subId>/resourceGroups/rg-exempt",
    #   "/subscriptions/<subId>/resourceGroups/rg-legacy"
    # ]
  }

  enforce_environment_tag = {
    name                   = "enforce-environment-tag"
    mode                   = "All"
    assignment_name        = "enforce-environment-tag-assignment"
    scope_type             = "subscription"
    scope_name             = "dev-subscription"
    display_name           = "Enforce Environment Tag"
    description            = "Requires 'Environment' tag on all resources."
    policy_rule            = file("${path.module}/policies/enforce_environment_tag.json")
    metadata               = file("${path.module}/policies/enforce_environment_tag.metadata.json")
    parameters             = jsonencode({})
    non_compliance_message = "All resources must include the 'Environment' tag."
    # Optional examples for identity and not_scopes as above
  }
}

builtin_policies = {
  allowed-locations = {
    policy_name            = "Allowed locations"
    assignment_name        = "allowed-locations-assignment"
    scope_type             = "subscription"
    scope_name             = "dev-subscription"
    display_name           = "Allowed Locations"
    description            = "Restricts the locations where resources can be deployed."
    parameters             = jsonencode({
      listOfAllowedLocations = {
        value = ["eastus", "centralus"]
      }
    })
    non_compliance_message = "Only 'eastus' and 'centralus' are allowed."
    # Optional: identity and not_scopes
    # identity_type = "SystemAssigned"
    # not_scopes    = [
    #   "/subscriptions/<subId>/resourceGroups/rg-exempt"
    # ]
  }

  audit-vm-no-antimalware = {
    policy_name            = "Audit VMs without antimalware"
    assignment_name        = "audit-vm-no-antimalware-assignment"
    scope_type             = "management_group"
    scope_name             = "mg-platform"
    display_name           = "Audit VMs Without Antimalware"
    description            = "Audits VMs that do not have antimalware installed."
    parameters             = jsonencode({})
    non_compliance_message = "Ensure all VMs have antimalware installed."
    # identity_type = "UserAssigned"
    # identity_ids  = ["/subscriptions/<subId>/resourceGroups/<rg>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<uaiName>"]
  }

## Policy initiative

```tf
policy_initiatives = {
  security_baseline = {
    name                   = "Security-Baseline-Initiative"
    display_name           = "Security Baseline Initiative"
    description            = "A comprehensive security baseline initiative for Azure resources."
    policy_type            = "Custom"
    assignment_name        = "security-baseline"
    scope_type             = "management_group"
    scope_name             = "mg-platform"
    parameters             = jsonencode({
      effect = {
        type = "String"
        value = "Audit"
      }
      allowedLocations = {
        type = "Array"
        value = ["eastus", "westus2"]
      }
    })
    non_compliance_message = "Resources must comply with security baseline requirements."
    identity_type          = "SystemAssigned"
    policy_definitions = [
      {
        policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/1c6e92c9-99f0-4e55-9cf2-0c99dcf3acec"
        parameter_values = jsonencode({
          effect = {
            type = "String"
            value = "Audit"
          }
        })
      },
      {
        policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988"
        parameter_values = jsonencode({
          listOfAllowedLocations = {
            type = "Array"
            value = ["eastus", "westus2"]
          }
        })
      }
    ]
  }
}
```

### Policy Initiative Features

This example demonstrates how to deploy an Azure Policy Initiative (Policy Set) that:

1. **Groups Multiple Policies**: Combines related policies into a single initiative
2. **Parameter Management**: Handles both initiative-level and policy-level parameters
3. **Flexible Assignment**: Can be assigned to management groups or subscriptions
4. **Identity Support**: Supports both system-assigned and user-assigned identities

### Key Components

- **`name`**: The policy initiative name in Azure
- **`display_name`**: User-friendly display name
- **`description`**: Detailed description of the initiative
- **`policy_type`**: "Custom" for custom initiatives, "BuiltIn" for built-in ones
- **`assignment_name`**: Unique name for the policy assignment (max 24 characters)
- **`scope_type`**: "management_group" or "subscription"
- **`scope_name`**: Target scope name
- **`parameters`**: Initiative-level parameters (optional)
- **`non_compliance_message`**: Message shown when policy is non-compliant
- **`identity_type`**: "SystemAssigned" or "UserAssigned" for managed identity
- **`policy_definitions`**: List of policy definitions with their parameter values

### Parameter Structure

Each parameter in `parameter_values` must include:
- **`type`**: "String" or "Array" depending on the parameter type
- **`value`**: The actual parameter value

### Usage Notes

1. **Assignment Names**: Must be 24 characters or less
2. **Parameter Types**: Use "String" for single values, "Array" for lists
3. **Policy IDs**: Use full Azure policy definition IDs
4. **Scope Targeting**: Ensure the target scope exists before assignment
5. **Identity Requirements**: Some policies require managed identities for remediation

}
```