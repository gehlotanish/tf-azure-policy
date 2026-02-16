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
module "azure_policy" {
  source = "path/to/tf-azure-policy"

  builtin_policies = {
    "allowed-locations" = {
      policy_name            = "Allowed locations"
      assignment_name        = "allowed-loc-assign"
      scope_type             = "management_group"
      scope_name             = "group1"
      display_name           = "Allowed Locations"
      description            = "Restricts where resources can be deployed."
      assignment_parameters  = jsonencode({
        listOfAllowedLocations = {
          value = ["eastus", "centralus"]
        }
      })
      non_compliance_message = "Only eastus and centralus are allowed."
    }
  }

  custom_policies = {
    "deny-subnet-without-nsg" = {
      name                   = "deny-subnet-without-nsg"
      mode                   = jsondecode(file("${path.module}/policies/deny-subnet-without-nsg.json")).mode
      assignment_name        = "deny-subnet-no-nsg"
      scope_type             = "management_group"
      scope_name             = "group1"
      display_name           = jsondecode(file("${path.module}/policies/deny-subnet-without-nsg.json")).displayName
      description            = jsondecode(file("${path.module}/policies/deny-subnet-without-nsg.json")).description
      policy_rule            = jsonencode(jsondecode(file("${path.module}/policies/deny-subnet-without-nsg.json")).policyRule)
      metadata               = jsonencode({ category = "Network", version = "1.0.0" })
      non_compliance_message = "Subnets must have an NSG attached."
    }

    # Example modify policy: requires assignment identity + assignment parameters
    "inherit-tag-from-rg-if-missing" = {
      name                   = "inherit-tag-from-rg-if-missing"
      mode                   = jsondecode(file("${path.module}/policies/inherit-tag-from-rg-if-missing.json")).mode
      assignment_name        = "inherit-tag-from-rg"
      scope_type             = "management_group"
      scope_name             = "group1"
      display_name           = jsondecode(file("${path.module}/policies/inherit-tag-from-rg-if-missing.json")).displayName
      description            = jsondecode(file("${path.module}/policies/inherit-tag-from-rg-if-missing.json")).description
      policy_rule            = jsonencode(jsondecode(file("${path.module}/policies/inherit-tag-from-rg-if-missing.json")).policyRule)
      metadata               = jsonencode(jsondecode(file("${path.module}/policies/inherit-tag-from-rg-if-missing.json")).metadata)
      parameters             = jsonencode(jsondecode(file("${path.module}/policies/inherit-tag-from-rg-if-missing.json")).parameters)
      assignment_parameters  = jsonencode({
        tagName = {
          value = "owner"
        }
      })
      identity_type          = "SystemAssigned"
      non_compliance_message = "Missing tags are inherited from the resource group."
    }
  }
}
```

### Notes

- Use `assignment_parameters` for policy assignment input values.
- For custom definitions, pass `policy_rule`, `metadata`, and optional `parameters` as JSON strings.
- Use `identity_type = "SystemAssigned"` (or `UserAssigned`) when the policy effect needs an identity (for example, `modify`).
- `scope_name` must match the management group display/name or subscription display name expected by this module lookups.