# terraform code for azure policies

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.33.0 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.25.0 |
## Modules

No modules.
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_builtin_policies"></a> [builtin\_policies](#input\_builtin\_policies) | Map of built-in policy assignments to apply at either the subscription or management group level.<br/><br/>Key: Built-in policy definition name.<br/><br/>Each object must include:<br/>- policy\_name: The actual name of the policy definition in Azure.<br/>- assignment\_name: Unique name for the policy assignment.<br/>- scope\_type: "subscription" or "management\_group".<br/>- scope\_name: The display name of the target scope (as shown in the Azure Portal).<br/>- display\_name: Friendly display name for the policy assignment.<br/>- description: Description of the policy assignment.<br/>- parameters: Optional parameters for the policy definition (can be `null`).<br/>- non\_compliance\_message: Message to display when the policy is non-compliant. | <pre>map(object({<br/>    policy_name            = string<br/>    assignment_name        = string<br/>    scope_type             = string<br/>    scope_name             = string<br/>    display_name           = string<br/>    description            = string<br/>    parameters             = any<br/>    non_compliance_message = string<br/>    identity_type          = optional(string)<br/>    identity_ids           = optional(list(string))<br/>  }))</pre> | `{}` | no |
| <a name="input_custom_policies"></a> [custom\_policies](#input\_custom\_policies) | Map of custom policy definitions and their assignments.<br/><br/>Key: Custom policy definition name.<br/><br/>Each object must include:<br/>- name: The actual name of the policy definition in Azure.<br/>- mode: "All", "Indexed", or another supported Azure policy mode.<br/>- assignment\_name: Unique name for the policy assignment.<br/>- scope\_type: "subscription" or "management\_group".<br/>- scope\_name: The display name of the target scope (as shown in the Azure Portal).<br/>- display\_name: Friendly display name for the policy assignment.<br/>- description: Description of the policy assignment.<br/>- policy\_rule: JSON-encoded string representing the policy rule.<br/>- metadata: JSON-encoded string representing policy metadata.<br/>- parameters: Optional parameters for the policy definition (can be `null`).<br/>- non\_compliance\_message: Message to display when the policy is non-compliant. | <pre>map(object({<br/>    name                   = string<br/>    mode                   = string<br/>    assignment_name        = string<br/>    scope_type             = string<br/>    scope_name             = string<br/>    display_name           = string<br/>    description            = string<br/>    policy_rule            = string<br/>    metadata               = string<br/>    parameters             = any<br/>    non_compliance_message = string<br/>    identity_type          = optional(string)<br/>    identity_ids           = optional(list(string))<br/>  }))</pre> | `{}` | no |  
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_builtin_policy_assignment_ids"></a> [builtin\_policy\_assignment\_ids](#output\_builtin\_policy\_assignment\_ids) | Map of built-in policy assignment names to their corresponding resource IDs. |
| <a name="output_custom_policy_assignment_ids"></a> [custom\_policy\_assignment\_ids](#output\_custom\_policy\_assignment\_ids) | Map of custom policy assignment names to their corresponding resource IDs. |
| <a name="output_custom_policy_definition_ids"></a> [custom\_policy\_definition\_ids](#output\_custom\_policy\_definition\_ids) | Map of custom policy names to their definition resource IDs. |
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
  }
}
```