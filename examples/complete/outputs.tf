output "vnets" {
  value = module.vnet.vnets
}

output "subnets" {
  value = { for s in module.vnet.subnets : s.name => {
    id = s.id
    name = s.name
    }
  }
}

output "subscriptionId" {
  value = module.vnet.subscriptionId
}