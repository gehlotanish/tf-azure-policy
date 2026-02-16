terraform {
  required_version = "~> 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.46.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "16a1efc2-499c-4f09-93b3-455774a44229"
}