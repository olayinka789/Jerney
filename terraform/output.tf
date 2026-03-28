output "aks_cluster_name" {
  description = "AKS cluster name"
  value       = module.aks.aks_name
}

output "aks_cluster_endpoint" {
  description = "AKS cluster API endpoint"
  value       = module.aks.host
  sensitive   = true
}

output "aks_cluster_ca_certificate" {
  description = "AKS cluster CA certificate (base64)"
  value       = module.aks.cluster_ca_certificate
  sensitive   = true
}

output "vnet_id" {
  description = "Virtual Network ID"
  value       = module.vnet.resource_id
}

output "azure_region" {
  description = "Azure region"
  value       = var.azure_location
}

output "resource_group_name" {
  description = "Resource Group name"
  value       = azurerm_resource_group.rg.name
}
