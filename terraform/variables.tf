variable "azure_location" {
  description = "Azure region to deploy the resources"
  type        = string
  default     = "UK South"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "jerney-aks"
}

variable "kubernetes_version" {
  description = "Kubernetes version for AKS"
  type        = string
  default     = "1.32"
}

variable "vnet_cidr" {
  description = "CIDR block for the Azure Virtual Network"
  type        = string
  default     = "10.0.0.0/16"
}