# Azure DNS Zones Terraform module

Terraform module which creates Azure DNS Zones resources on Azure.

These types of resources are supported:

* [Azure DNS](https://learn.microsoft.com/en-us/azure/dns/dns-overview)
* [Azure Private DNS](https://learn.microsoft.com/en-us/azure/dns/private-dns-overview)

## Terraform versions

Terraform 1.5.6 and newer.

## Usage

```hcl
module "public-zones" {
  source              = "jsathler/dns-zone/azurerm"
  resource_group_name = azurerm_resource_group.default.name
  zones = {
    "examplezone.com" = {}
    "examplezone.net" = { soa = { email = "contact.example.com" } }
  }
}
```

```hcl
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
```

More samples in examples folder