# Define the resource group
resource "azurerm_resource_group" "example" {
  name     = "var.example-rg"
  location = "eastus"
}

locals {
  rgname = "${azurerm_resource_group.example.name}"
}

# Define the Virtual Network
resource "azurerm_virtual_network" "example_vnet" {
  name                = "var.example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.example.location}"
  resource_group_name = "${azurerm_resource_group.example.name}"
}

# Define the Subnet
resource "azurerm_subnet" "example_subnet" {
  name                 = "var.example-subnet"
  resource_group_name  = local.rgname
  virtual_network_name = "${azurerm_virtual_network.example_vnet.name}"
  address_prefixes     = ["10.0.1.0/24"]
}
