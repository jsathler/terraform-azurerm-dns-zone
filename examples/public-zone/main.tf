provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "default" {
  name     = "publiczone-example-rg"
  location = "northeurope"
}

module "public-zones" {
  source              = "../../"
  resource_group_name = azurerm_resource_group.default.name
  zones = {
    "examplezone.com" = {}
    "examplezone.net" = { soa = { email = "contact.example.com" } }
  }
}

output "public-zones" {
  value = module.public-zones
}
