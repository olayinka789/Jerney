# ==============================================================
# Jerney AKS Cluster (Auto-Mode Baseline)
# ==============================================================

# ---- Resource Group ----
resource "azurerm_resource_group" "rg" {
  name     = "${var.aks_cluster_name}-rg"
  location = var.azure_location
}

# ---- Virtual Network ----
module "vnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "~> 0.17"

  name                = "vnet-${var.aks_cluster_name}"
  location            = azurerm_resource_group.rg.location
  parent_id           = azurerm_resource_group.rg.id

  address_space = [var.vnet_cidr]

  subnets = {
    web = {
      name             = "snet-web"
      address_prefixes = ["10.0.1.0/24"]
    }
    app = {
      name             = "snet-app"
      address_prefixes = ["10.0.2.0/24"]
    }
    data = {
      name             = "snet-data"
      address_prefixes = ["10.0.3.0/24"]
      service_endpoints_with_location = [
        { service = "Microsoft.Sql" },
        { service = "Microsoft.Storage" }
      ]
    }
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}   

# ---- AKS Cluster ----
module "aks" {
  source              = "Azure/aks/azurerm"
  version             = "11.0.0"
  resource_group_name = azurerm_resource_group.rg.name
  cluster_name        = var.aks_cluster_name
  kubernetes_version  = var.kubernetes_version
  location            = azurerm_resource_group.rg.location
  prefix              = var.aks_cluster_name

  create_role_assignments_for_application_gateway = false

  net_profile_service_cidr = "172.16.0.0/16"
  net_profile_dns_service_ip = "172.16.0.10"

  vnet_subnet         = { id = module.vnet.subnets["app"].resource_id }

  auto_scaling_enabled = true
  agents_min_count     = 1
  agents_max_count     = 5
  agents_count         = 2
  agents_size          = "Standard_B4ms"
  agents_pool_name     = "system"

  tags = {
    env  = var.environment
    team = "platform"
  }
}   
