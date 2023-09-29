module "private-zones" {
  source              = "jsathler/dns-zone/azurerm"
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
