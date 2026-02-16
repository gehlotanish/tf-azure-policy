terraform {
  required_version = "~> 1.5"
}

module "builtin_policies" {
  source = "../"

  builtin_policies = {
    "allowed-locations" = {
      policy_name     = "Allowed locations"
      assignment_name = "allowed-loc-assign"
      scope_type      = "management_group"
      scope_name      = "group1"
      display_name    = "Allowed Locations"
      description     = "Restricts the locations where resources can be deployed."
      assignment_parameters = jsonencode({
        listOfAllowedLocations = {
          value = ["eastus", "centralus"]
        }
      })
      non_compliance_message = "Only eastus and centralus are allowed."
    }

  }

  custom_policies = {
    "enforce-owner-tag-on-rg" = {
      name                   = "enforce-owner-tag-on-rg"
      mode                   = jsondecode(file("${path.module}/../policies/enforce-owner-tag-on-rg.json")).mode
      assignment_name        = "enforce-owner-rg"
      scope_type             = "management_group"
      scope_name             = "group1"
      display_name           = "Enforce owner tag on resource groups"
      description            = "Denies resource groups without a valid owner tag."
      policy_rule            = jsonencode(jsondecode(file("${path.module}/../policies/enforce-owner-tag-on-rg.json")).policyRule)
      metadata               = jsonencode({ category = "Tags", version = "1.0.0" })
      non_compliance_message = "Resource groups must have a valid owner tag."
    }

    "disallow-storage-public-access" = {
      name                   = "disallow-storage-public-access"
      mode                   = jsondecode(file("${path.module}/../policies/deny-publicnetwork-storage.json")).mode
      assignment_name        = "disallow-public-access"
      scope_type             = "management_group"
      scope_name             = "group1"
      display_name           = jsondecode(file("${path.module}/../policies/deny-publicnetwork-storage.json")).displayName
      description            = jsondecode(file("${path.module}/../policies/deny-publicnetwork-storage.json")).description
      policy_rule            = jsonencode(jsondecode(file("${path.module}/../policies/deny-publicnetwork-storage.json")).policyRule)
      metadata               = jsonencode({ category = "Storage", version = "1.0.0" })
      non_compliance_message = "Storage account allows public access. Disable public access to comply."
    }

    "deny-subnet-without-nsg" = {
      name                   = "deny-subnet-without-nsg"
      mode                   = jsondecode(file("${path.module}/../policies/deny-subnet-without-nsg.json")).mode
      assignment_name        = "deny-subnet-no-nsg"
      scope_type             = "management_group"
      scope_name             = "group1"
      display_name           = jsondecode(file("${path.module}/../policies/deny-subnet-without-nsg.json")).displayName
      description            = jsondecode(file("${path.module}/../policies/deny-subnet-without-nsg.json")).description
      policy_rule            = jsonencode(jsondecode(file("${path.module}/../policies/deny-subnet-without-nsg.json")).policyRule)
      metadata               = jsonencode({ category = "Network", version = "1.0.0" })
      non_compliance_message = "Subnets must have an NSG attached."
    }

    "inherit-tag-from-rg-if-missing" = {
      name            = "inherit-tag-from-rg-if-missing"
      mode            = jsondecode(file("${path.module}/../policies/inherit-tag-from-rg-if-missing.json")).mode
      assignment_name = "inherit-tag-from-rg"
      scope_type      = "management_group"
      scope_name      = "group1"
      display_name    = jsondecode(file("${path.module}/../policies/inherit-tag-from-rg-if-missing.json")).displayName
      description     = jsondecode(file("${path.module}/../policies/inherit-tag-from-rg-if-missing.json")).description
      policy_rule     = jsonencode(jsondecode(file("${path.module}/../policies/inherit-tag-from-rg-if-missing.json")).policyRule)
      metadata        = jsonencode(jsondecode(file("${path.module}/../policies/inherit-tag-from-rg-if-missing.json")).metadata)
      parameters      = jsonencode(jsondecode(file("${path.module}/../policies/inherit-tag-from-rg-if-missing.json")).parameters)
      assignment_parameters = jsonencode({
        tagName = {
          value = "owner"
        }
      })
      identity_type          = "SystemAssigned"
      non_compliance_message = "Missing tags are inherited from the resource group."
    }

    "enforce-owner-tag-on-kv" = {
      name                   = "enforce-owner-tag-on-kv"
      mode                   = jsondecode(file("${path.module}/../policies/enforce-owner-tag-on-kv.json")).mode
      assignment_name        = "enforce-owner-kv"
      scope_type             = "management_group"
      scope_name             = "group1"
      display_name           = "Enforce owner tag on key vault"
      description            = "Denies key vaults without a valid owner tag."
      policy_rule            = jsonencode(jsondecode(file("${path.module}/../policies/enforce-owner-tag-on-kv.json")).policyRule)
      metadata               = jsonencode({ category = "Tags", version = "1.0.0" })
      non_compliance_message = "Key vaults must have a valid owner tag."
    }

    "deny-vnet-peering" = {
      name            = "deny-vnet-peering"
      mode            = jsondecode(file("${path.module}/../policies/deny-vnet-peering.json")).mode
      assignment_name = "deny-vnet-peering"
      scope_type      = "management_group"
      scope_name      = "group1"
      display_name    = "Deny VNet peering"
      description     = "Denies creation of virtual network peering."
      policy_rule     = jsonencode(jsondecode(file("${path.module}/../policies/deny-vnet-peering.json")).policyRule)
      metadata        = jsonencode({ category = "Network", version = "1.0.0" })
      parameters      = jsonencode(jsondecode(file("${path.module}/../policies/deny-vnet-peering.json")).parameters)
      assignment_parameters = jsonencode({
        Effect = {
          value = "Deny"
        }
      })
      non_compliance_message = "Virtual network peering is not allowed."
    }

    "deny-public-dns-zones" = {
      name                   = "deny-public-dns-zones"
      mode                   = jsondecode(file("${path.module}/../policies/deny-public-dns-zones.json")).mode
      assignment_name        = "deny-public-dns"
      scope_type             = "management_group"
      scope_name             = "group1"
      display_name           = jsondecode(file("${path.module}/../policies/deny-public-dns-zones.json")).displayName
      description            = jsondecode(file("${path.module}/../policies/deny-public-dns-zones.json")).description
      policy_rule            = jsonencode(jsondecode(file("${path.module}/../policies/deny-public-dns-zones.json")).policyRule)
      metadata               = jsonencode({ category = "Network", version = "1.0.0" })
      non_compliance_message = "Public DNS zone creation is not allowed."
    }

    "deny-private-dns-zones" = {
      name                   = "deny-private-dns-zones"
      mode                   = jsondecode(file("${path.module}/../policies/deny-private-dns-zones.json")).mode
      assignment_name        = "deny-private-dns"
      scope_type             = "management_group"
      scope_name             = "group1"
      display_name           = jsondecode(file("${path.module}/../policies/deny-private-dns-zones.json")).displayName
      description            = jsondecode(file("${path.module}/../policies/deny-private-dns-zones.json")).description
      policy_rule            = jsonencode(jsondecode(file("${path.module}/../policies/deny-private-dns-zones.json")).policyRule)
      metadata               = jsonencode({ category = "Network", version = "1.0.0" })
      non_compliance_message = "Private DNS zones with privatelink prefix are restricted."
    }

    "restrict-vm-skus" = {
      name                   = "restrict-vm-skus"
      mode                   = jsondecode(file("${path.module}/../policies/restrict-vm-skus.json")).mode
      assignment_name        = "restrict-vm-skus"
      scope_type             = "management_group"
      scope_name             = "group1"
      display_name           = "Restrict VM SKUs"
      description            = "Allows only approved VM SKU families."
      policy_rule            = jsonencode(jsondecode(file("${path.module}/../policies/restrict-vm-skus.json")).policyRule)
      metadata               = jsonencode({ category = "Compute", version = "1.0.0" })
      non_compliance_message = "Requested VM SKU is not allowed."
    }

    "deny-api-mgmt-tls12" = {
      name                   = "deny-api-mgmt-tls12"
      mode                   = jsondecode(file("${path.module}/../policies/Deny-API-mgmt-Srv-tsl1.2.json")).mode
      assignment_name        = "deny-apim-tls12"
      scope_type             = "management_group"
      scope_name             = "group1"
      display_name           = jsondecode(file("${path.module}/../policies/Deny-API-mgmt-Srv-tsl1.2.json")).displayName
      description            = jsondecode(file("${path.module}/../policies/Deny-API-mgmt-Srv-tsl1.2.json")).description
      policy_rule            = jsonencode(jsondecode(file("${path.module}/../policies/Deny-API-mgmt-Srv-tsl1.2.json")).policyRule)
      metadata               = jsonencode({ category = "Security", version = "1.0.0" })
      non_compliance_message = "API Management must not enable TLS 1.0/1.1."
    }

    "audit-ownerroles-policy" = {
      name                   = "audit-ownerroles-policy"
      mode                   = jsondecode(file("${path.module}/../policies/audit-ownerroles-policy.json")).mode
      assignment_name        = "audit-owner-roles"
      scope_type             = "management_group"
      scope_name             = "group1"
      display_name           = jsondecode(file("${path.module}/../policies/audit-ownerroles-policy.json")).displayName
      description            = jsondecode(file("${path.module}/../policies/audit-ownerroles-policy.json")).description
      policy_rule            = jsonencode(jsondecode(file("${path.module}/../policies/audit-ownerroles-policy.json")).policyRule)
      metadata               = jsonencode(jsondecode(file("${path.module}/../policies/audit-ownerroles-policy.json")).metadata)
      parameters             = jsonencode(jsondecode(file("${path.module}/../policies/audit-ownerroles-policy.json")).parameters)
      non_compliance_message = "Owner role assignments are audited."
    }

    "audit-builtin-roles" = {
      name                   = "audit-builtin-roles"
      mode                   = jsondecode(file("${path.module}/../policies/audit-builtin-roles.json")).mode
      assignment_name        = "audit-builtin-roles"
      scope_type             = "management_group"
      scope_name             = "group1"
      display_name           = jsondecode(file("${path.module}/../policies/audit-builtin-roles.json")).displayName
      description            = jsondecode(file("${path.module}/../policies/audit-builtin-roles.json")).description
      policy_rule            = jsonencode(jsondecode(file("${path.module}/../policies/audit-builtin-roles.json")).policyRule)
      metadata               = jsonencode(jsondecode(file("${path.module}/../policies/audit-builtin-roles.json")).metadata)
      parameters             = jsonencode(jsondecode(file("${path.module}/../policies/audit-builtin-roles.json")).parameters)
      non_compliance_message = "Built-in privileged role assignments are audited."
    }

    "enforce-required-tags" = {
      name                   = "enforce-required-tags"
      mode                   = jsondecode(file("${path.module}/../policies/enforce_required_tags.json")).mode
      assignment_name        = "enforce-required-tags"
      scope_type             = "management_group"
      scope_name             = "group1"
      display_name           = "Enforce Required Tags"
      description            = "Denies resources when required tag policy conditions are not met."
      policy_rule            = jsonencode(jsondecode(file("${path.module}/../policies/enforce_required_tags.json")).policyRule)
      metadata               = jsonencode({ category = "Tags", version = "1.0.0" })
      non_compliance_message = "Required tags policy is enforced."
    }
  }
}