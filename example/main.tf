provider "azurerm" {
  features {}
}

terraform {
  required_version = "~> 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.33.0"
    }
  }
}

module "policy" {
  source = "../"

  builtin_policies = {
    require_tags = {
      policy_name            = "Require a tag on resource groups"
      assignment_name        = "require-team-tag"
      display_name           = "Enforce tag 'team' with specific value"
      description            = "Ensures all resources have a 'team' tag with a specified value"
      scope_type             = "management_group"
      scope_name             = "group1" # Replace with your MG name
      non_compliance_message = "add `team` as tag"
      parameters = jsonencode({
        tagName = {
          value = "team"
        }
      })
    }

    allowed-locations = {
      policy_name            = "Allowed locations"
      assignment_name        = "Allowed-locations"
      display_name           = "Enforce Allowed locations"
      description            = "Ensures all resources in Allowed locations"
      scope_type             = "management_group"
      scope_name             = "group1" # Replace with your MG name
      non_compliance_message = "Ensures Respurce deployed in westus2"
      parameters = jsonencode({
        listOfAllowedLocations = {
          value = ["westus2"]
        }
      })
    }
  }

  custom_policies = {}

}