locals {
  tags = merge(var.tags, { ManagedByTerraform = "True" })
}

resource "azurerm_dns_zone" "default" {
  for_each            = { for key, value in var.zones : key => value if value.private == false }
  name                = each.key
  resource_group_name = var.resource_group_name
  tags                = local.tags

  dynamic "soa_record" {
    for_each = each.value.soa == null ? [] : [each.value.soa]
    content {
      email         = soa_record.value.email
      expire_time   = soa_record.value.expire_time
      minimum_ttl   = soa_record.value.minimum_ttl
      refresh_time  = soa_record.value.refresh_time
      retry_time    = soa_record.value.refresh_time
      serial_number = soa_record.value.retry_time
      ttl           = soa_record.value.serial_number
    }
  }
}

resource "azurerm_private_dns_zone" "default" {
  for_each            = { for key, value in var.zones : key => value if value.private && value.link_only == false }
  name                = each.key
  resource_group_name = var.resource_group_name
  tags                = local.tags

  dynamic "soa_record" {
    for_each = each.value.soa == null ? [] : [each.value.soa]
    content {
      email         = soa_record.value.email
      expire_time   = soa_record.value.expire_time
      minimum_ttl   = soa_record.value.minimum_ttl
      refresh_time  = soa_record.value.refresh_time
      retry_time    = soa_record.value.refresh_time
      serial_number = soa_record.value.retry_time
      ttl           = soa_record.value.serial_number
    }
  }
}

locals {
  /* 
  Creating a new list of zones vs vnet since each zone can have more than 1 vnet
  */
  private_zone_links = flatten([for zone_key, zone_value in var.zones : [
    for vnet_key, vnet_value in zone_value.vnets : {
      private_dns_zone_name = zone_key
      resource_group_name   = var.resource_group_name
      virtual_network_id    = vnet_value.id
      virtual_network_name  = split("/", vnet_value.id)[8]
      registration_enabled  = vnet_value.registration_enabled
      link_only             = zone_value.link_only
      link_name             = vnet_key
    }
  ] if zone_value.private == true && zone_value.vnets != null])
}

/*
If you are creating the vNet at same time you are creating the private zone, vnet id is not yet available and can't be used as key in for_each
We considered using the map key (0, 1, 2, etc) but if the vnets order is changed, links would be recreated
As solution we decided to create the link_name in the private_zone_links, it will be used as key in conjunction with zone name
*/
resource "azurerm_private_dns_zone_virtual_network_link" "default" {
  for_each              = { for key, value in local.private_zone_links : "${value.private_dns_zone_name}-${value.link_name}" => value }
  name                  = "${each.value.link_name}-pnetlk"
  private_dns_zone_name = each.value.link_only ? each.value.private_dns_zone_name : azurerm_private_dns_zone.default[each.value.private_dns_zone_name].name
  resource_group_name   = each.value.resource_group_name
  virtual_network_id    = each.value.virtual_network_id
  registration_enabled  = each.value.registration_enabled
  tags                  = local.tags
}
