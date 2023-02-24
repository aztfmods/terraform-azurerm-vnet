output "vnets" {
  value = module.vnet.vnets
}

# output "subnets" {
#   value = values(module.vnet.subnets)[*].name
# }

output "subnets" {
  value = { for s in module.vnet.subnets : s.name => {
    id   = s.id
    name = s.name
    }
  }
}


output "subscriptionId" {
  value = module.vnet.subscriptionId
}

#laatste
# output "subnets" {
#   value = { for k, v in module.vnet.subnets : k => {
#     "name" = v.name
#     "id" = v.id
#     }
#   }
# }

# output "subnets" {
#   value = tomap(
#   { for k, v in module.vnet.subnets : k => {
#       "name" = v.name
#       "id" = v.id
#       }
#     }
#   )
# }

# output "subnets" {
#   value = {
#     for subnet_name, subnet in module.vnet.subnets :
#     subnet_name => {
#       id = subnet.id
#       name = subnet.name
#       address_prefix = subnet.address_prefixes[0]
#     }
#   }
# }

# output "subnets" {
#   value = {
#     "sn-cn-sn1-p-weu" = {
#       id              = azurerm_subnet.subnet1.id
#       name            = azurerm_subnet.subnet1.name
#       address_prefix  = azurerm_subnet.subnet1.address_prefixes[0]
#     }
#     "sn-cn-sn2-p-weu" = {
#       id              = azurerm_subnet.subnet2.id
#       name            = azurerm_subnet.subnet2.name
#       address_prefix  = azurerm_subnet.subnet2.address_prefixes[0]
#     }
#   }
# }

# output "subnets" {
#   value = {
#     for s in module.vnet.subnets :
#     s.name => {
#       id = s.id
#     }
#   }
# }

# subnets = {
#   "sn-cn-sn1-p-weu" = {
#     "id" = "/subscriptions/cb3cf69c-4cb7-4e42-8fd8-1aae3624f329/resourceGroups/rg-cn-demo-p-weu/providers/Microsoft.Network/virtualNetworks/vnet-demo/subnets/sn-cn-sn1-p-weu"
#   }
#   "sn-cn-sn2-p-weu" = {
#     "id" = "/subscriptions/cb3cf69c-4cb7-4e42-8fd8-1aae3624f329/resourceGroups/rg-cn-demo-p-weu/providers/Microsoft.Network/virtualNetworks/vnet-demo/subnets/sn-cn-sn2-p-weu"
#   }
# }

# subnets = [
#   sn-cn-sn1-p-weu,
#   sn-cn-sn2-p-weu
# ]