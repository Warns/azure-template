provider "azurerm" {
  version         = "=2.5.0"
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id

  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "${var.prefix}azuretemplate-aks-resources"
    storage_account_name = "azuretemplate"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}azuretemplate-aks-resources"
  location = var.location
}

# Create Container Registry
resource "azurerm_container_registry" "acr" {
  name                = "${var.prefix}azuretemplateregistry"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
}

resource "azurerm_virtual_network" "vn" {
  name                = "${var.prefix}-azuretemplateVnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["192.168.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}-azuretemplatesubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefix       = "192.168.1.0/24"
  virtual_network_name = azurerm_virtual_network.vn.name
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-azuretemplateaks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "azuretemplate-dns-prefix"

  default_node_pool {
    name           = "azuretemplatepool"
    node_count     = 1
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "Standard"
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }
}

data "azurerm_public_ip" "pip" {
  name                = reverse(split("/", tolist(azurerm_kubernetes_cluster.aks.network_profile.0.load_balancer_profile.0.effective_outbound_ips)[0]))[0]
  resource_group_name = azurerm_kubernetes_cluster.aks.node_resource_group
}
