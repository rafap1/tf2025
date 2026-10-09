## azurerm has no equivalent of AWS default_tags / GCP default_labels.
## Tags are defined once in local.common_tags (see locals.tf) and merged into every taggable resource.
provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}
