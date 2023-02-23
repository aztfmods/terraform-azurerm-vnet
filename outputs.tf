output "vnets" {
  value = azurerm_virtual_network.vnets
}

output "subnets" {
  value = azurerm_subnet.subnets
}

output "subscriptionId" {
  value = data.azurerm_subscription.current.subscription_id
}

# output "merged_ids" {
#   value = concat(values(azurerm_virtual_network.vnets)[*].id, values(azurerm_network_security_group.nsg)[*].id)
# }