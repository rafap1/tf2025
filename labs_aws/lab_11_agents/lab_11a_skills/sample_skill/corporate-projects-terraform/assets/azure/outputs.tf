output "tenant_id" {
  description = "Azure AD tenant used by Terraform"
  value       = data.azurerm_client_config.current.tenant_id
}

output "subscription_id" {
  description = "Subscription where Terraform deploys resources"
  value       = data.azurerm_client_config.current.subscription_id
}

output "resource_group_name" {
  description = "Name of the main resource group"
  value       = azurerm_resource_group.main.name
}
