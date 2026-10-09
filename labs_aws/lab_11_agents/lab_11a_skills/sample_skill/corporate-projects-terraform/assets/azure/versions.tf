terraform {
  required_version = "1.15.1" ## In production we pin terraform version to a specific one

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.9.0" ## Placeholder - in production we pin provider to a fixed version
    }
  }
}
