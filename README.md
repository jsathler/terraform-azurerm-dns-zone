<!-- BEGIN_TF_DOCS -->
# Azure DNS Zones Terraform module

Terraform module which creates Azure DNS Zones resources on Azure.

Supported Azure services:

* [Azure DNS](https://learn.microsoft.com/en-us/azure/dns/dns-overview)
* [Azure Private DNS](https://learn.microsoft.com/en-us/azure/dns/private-dns-overview)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.70.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.70.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_dns_zone.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone) | resource |
| [azurerm_private_dns_zone.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which the VGW will be created. This parameter is required | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to resources. | `map(string)` | `null` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | A MAP of dns zones to be created. The key is the zone name and the value are the properties<br>  - private:                (optional) If true, the zone will be created as "private zone" otherwise it will be created as "public zone". Defaults to 'false'<br>  - link\_only:              (optional) If true, only the vnet link will be created. In this case the private zone should already exist. Defaults to 'false'<br>  - vnets:                  (optional) A block as defined bellow (MAP of vnets)<br>    - id:                   (required) The ID of the Virtual Network that should be linked to the DNS Zone<br>    - registration\_enabled: (Optional) Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled? Defaults to 'false'<br>  - soa:                    (optional) A block as defined bellow<br>    - email:                (Required) The email contact for the SOA record. Defaults to 'null'<br>    - expire\_time:          (optional) The expire time for the SOA record. Defaults to 'null'<br>    - minimum\_ttl:          (optional) The minimum Time To Live for the SOA record. By convention, it is used to determine the negative caching duration. Defaults to 'null'<br>    - refresh\_time:         (optional) The refresh time for the SOA record. Defaults to 'null'<br>    - retry\_time:           (optional) The retry time for the SOA record. Defaults to 'null'<br>    - serial\_number:        (optional) The serial number for the SOA record. Defaults to 'null'<br>    - ttl:                  (optional) The Time To Live of the SOA Record in seconds. Defaults to 'null' | <pre>map(object({<br>    private   = optional(bool, false)<br>    link_only = optional(bool, false)<br>    vnets = optional(map(object({<br>      id                   = string<br>      registration_enabled = optional(bool, false)<br>    })))<br>    soa = optional(object({<br>      email         = optional(string, null)<br>      expire_time   = optional(string, null)<br>      minimum_ttl   = optional(string, null)<br>      refresh_time  = optional(string, null)<br>      retry_time    = optional(string, null)<br>      serial_number = optional(string, null)<br>      ttl           = optional(string, null)<br>    }), null)<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_zone_ids"></a> [private\_zone\_ids](#output\_private\_zone\_ids) | n/a |
| <a name="output_public_zone_ids"></a> [public\_zone\_ids](#output\_public\_zone\_ids) | n/a |
| <a name="output_public_zone_nameservers"></a> [public\_zone\_nameservers](#output\_public\_zone\_nameservers) | n/a |

## Examples
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
More examples in ./examples folder
<!-- END_TF_DOCS -->