output "vnets" {
  value = azurerm_virtual_network.vnets
}

output "vnet_ids" {
  value = values(azurerm_virtual_network.vnets)[*].id
}

output "nsg_ids" {
  value = values(azurerm_network_security_group.nsg)[*].id
}