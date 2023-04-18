terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}


# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  client_id       = "6081c0ae-2eab-4232-9e35-27950d2953d4"
  client_secret   = var.client_secret
  tenant_id       = "90b17b03-c9f7-4fa0-8776-2cea94e66da7"
  subscription_id = "95b65709-43f0-44fe-9659-da5fe6c359ea"
}

# Define the resource group
resource "azurerm_resource_group" "hub_rg" {
  name     = "hub_rg"
  location = "centralus"
}

locals {
  rgname = "hub_rg"
}

# Define the hub virtual network
resource "azurerm_virtual_network" "hub_vnet" {
  name                = "hub_vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.hub_rg.location}"
  resource_group_name = "hub_rg"
}

# Define the hub subnets
resource "azurerm_subnet" "firewall_subnet" {
  name                 = "firewall_subnet"
  resource_group_name  = "hub_rg"
  virtual_network_name = "${azurerm_virtual_network.hub_vnet.name}"
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = "bastion_subnet"
  resource_group_name  = "hub_rg"
  virtual_network_name = "${azurerm_virtual_network.hub_vnet.name}"
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "gateway_subnet" {
  name                 = "gateway_subnet"
  resource_group_name  = "hub_rg"
  virtual_network_name = "${azurerm_virtual_network.hub_vnet.name}"
  address_prefixes     = ["10.0.3.0/24"]
}

# Define the Azure Firewall
resource "azurerm_firewall" "firewall" {
  name                = "firewall"
  location            = "${azurerm_resource_group.hub_rg.location}"
  resource_group_name = "hub_rg"
  sku                 = "AZFW_VNet"
  ip_configuration {
    name                          = "firewall_ipconfig"
    subnet_id                     = "${azurerm_subnet.firewall_subnet.id}"
    public_ip_address_id          = "${azurerm_public_ip.firewall_public_ip.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

# Define the Azure Bastion
resource "azurerm_bastion_host" "bastion" {
  name                = "bastion"
  location            = "${azurerm_resource_group.hub_rg.location}"
  resource_group_name = "hub_rg"
  ip_configuration {
    name                          = "bastion_ipconfig"
    subnet_id                     = "${azurerm_subnet.bastion_subnet.id}"
    public_ip_address_id          = "${azurerm_public_ip.bastion_public_ip.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

# Define the Azure Virtual Network Gateway
resource "azurerm_virtual_network_gateway" "gateway" {
  name                = "gateway"
  location            = "${azurerm_resource_group.hub_rg.location}"
  resource_group_name = "hub_rg"
  type                = "Vpn"
  vpn_type            = "RouteBased"
  sku                 = "VpnGw1"
  active_active       = false

  ip_configuration {
    name                          = "gateway_ipconfig"
    subnet_id                     = "${azurerm_subnet.gateway_subnet.id}"
    public_ip_address_id          = "${azurerm_public_ip.gateway_public_ip.id}"
  }
}


