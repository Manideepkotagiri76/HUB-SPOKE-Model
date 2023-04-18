terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstatehello"
    container_name       = "tfstate"
    tenant_id       = "90b17b03-c9f7-4fa0-8776-2cea94e66da7"
    subscription_id = "95b65709-43f0-44fe-9659-da5fe6c359ea"
  }
}
