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
| <a name="input_builtin_policies"></a> [builtin\_policies](#input\_builtin\_policies) | Map of built-in policy assignments to apply at either the subscription or management group level.<br/><br/>Key: Built-in policy definition name.<br/><br/>Each object must include:<br/>- assignment\_name: Unique name for the policy assignment.<br/>- scope\_type: "subscription" or "management\_group".<br/>- scope\_name: The display name of the target scope (as shown in the Azure Portal).<br/>- display\_name: Friendly display name for the policy assignment.<br/>- description: Description of the policy assignment. | <pre>map(object({<br/>    policy_name            = string<br/>    assignment_name        = string<br/>    scope_type             = string<br/>    scope_name             = string<br/>    display_name           = string<br/>    description            = string<br/>    parameters             = any<br/>    non_compliance_message = string<br/>  }))</pre> | `{}` | no |
| <a name="input_custom_policies"></a> [custom\_policies](#input\_custom\_policies) | Map of custom policy definitions and their assignments.<br/><br/>Key: Custom policy definition name.<br/><br/>Each object must include:<br/>- mode: "All", "Indexed", or another supported Azure policy mode.<br/>- assignment\_name: Unique name for the policy assignment.<br/>- scope\_type: "subscription" or "management\_group".<br/>- scope\_name: The display name of the target scope (as shown in the Azure Portal).<br/>- display\_name: Friendly display name for the policy assignment.<br/>- description: Description of the policy assignment.<br/>- policy\_rule: JSON-encoded string representing the policy rule.<br/>- metadata: JSON-encoded string representing policy metadata. | <pre>map(object({<br/>    mode            = string<br/>    assignment_name = string<br/>    scope_type      = string<br/>    scope_name      = string<br/>    display_name    = string<br/>    description     = string<br/>    policy_rule     = string<br/>    metadata        = string<br/>  }))</pre> | `{}` | no |  
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_builtin_policy_assignment_ids"></a> [builtin\_policy\_assignment\_ids](#output\_builtin\_policy\_assignment\_ids) | Map of built-in policy assignment names to their corresponding resource IDs. |
| <a name="output_custom_policy_assignment_ids"></a> [custom\_policy\_assignment\_ids](#output\_custom\_policy\_assignment\_ids) | Map of custom policy assignment names to their corresponding resource IDs. |
| <a name="output_custom_policy_definition_ids"></a> [custom\_policy\_definition\_ids](#output\_custom\_policy\_definition\_ids) | Map of custom policy names to their definition resource IDs. |
<!-- END_TF_DOCS -->

## Usage

```tf
builtin_policies = {
  "Audit VMs that do not use managed disks" = {
    assignment_name = "audit-vms-no-managed-disk"
    scope_type      = "subscription"
    scope_name      = "Anish Dev Sub"
    display_name    = "Audit Unmanaged VMs"
    description     = "Audits virtual machines that are not using managed disks."
  }

  "Allowed locations" = {
    assignment_name = "enforce-allowed-locations"
    scope_type      = "management_group"
    scope_name      = "AnishRootMG"
    display_name    = "Allowed Locations"
    description     = "Restricts resource creation to specific Azure regions."
  }
}

custom_policies = {
  "deny-public-ip" = {
    mode             = "All"
    assignment_name  = "deny-public-ip-assignment"
    scope_type       = "subscription"
    scope_name       = "Anish Dev Sub"
    display_name     = "Deny Public IP Assignment"
    description      = "Prevents creation of Public IP addresses."
    policy_rule      = file("${path.module}/policies/deny_public_ip.json")
    metadata         = jsonencode({ category = "Network", version = "1.0.0" })
  }

  "tag-compliance-enforce" = {
    mode             = "All"
    assignment_name  = "enforce-required-tags"
    scope_type       = "management_group"
    scope_name       = "AnishRootMG"
    display_name     = "Enforce Required Tags"
    description      = "Ensures all resources have required tags."
    policy_rule      = file("${path.module}/policies/enforce_required_tags.json")
    metadata         = jsonencode({ category = "Tags", version = "1.1.0" })
  }
}
```