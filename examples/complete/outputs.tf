output "vnet" {
  value = module.network.vnet
}

output "subnets" {
  value = { for s in module.network.subnets : s.name => {
    id   = s.id
    name = s.name
    }
  }
}

output "subnet_service_endpoints" {
  value = { for subnet_name, service_endpoints in module.network.subnets : subnet_name => [for endpoint in service_endpoints : endpoint] }
}

output "subscriptionId" {
  value = module.network.subscriptionId
}
