provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "default" {
  name     = "privatezone-example-rg"
  location = "northeurope"
}

resource "azurerm_virtual_network" "example1" {
  name                = "example1-vnet"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  address_space       = ["10.0.0.0/24"]
}

resource "azurerm_virtual_network" "example2" {
  name                = "example2-vnet"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  address_space       = ["10.0.1.0/24"]
}

module "private-zones" {
  source              = "../../"
  resource_group_name = azurerm_resource_group.default.name
  zones = {
    "az.example.net" = {
      private = true
      vnets = {
        example1-vnet = { id = azurerm_virtual_network.example1.id, registration_enabled = true }
        example2-vnet = { id = azurerm_virtual_network.example2.id, registration_enabled = true }
      }
    }
    "privatelink.vaultcore.azure.net" = {
      private = true
      vnets = {
        example1-vnet = { id = azurerm_virtual_network.example1.id }
        example2-vnet = { id = azurerm_virtual_network.example2.id }
      }
    }
    "privatelink.blob.core.windows.net" = {
      private = true
      vnets = {
        "example2-vnet" = { id = azurerm_virtual_network.example2.id }
      }
      soa = {
        email = "contact.private.example.com"
      }
    }
  }
}

output "private-zones" {
  value = module.private-zones
}
