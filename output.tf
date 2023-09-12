output "public_zone_ids" {
  value = { for key, value in azurerm_dns_zone.default : value.name => value.id }
}

output "public_zone_nameservers" {
  value = { for key, value in azurerm_dns_zone.default : value.name => value.name_servers }
}

output "private_zone_ids" {
  value = { for key, value in azurerm_private_dns_zone.default : value.name => value.id }
}
