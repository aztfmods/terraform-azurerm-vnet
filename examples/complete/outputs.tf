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


# output "subnet_service_endpoints" {
#   value = {
#     for subnet in module.network.subnets : subnet.name => [
#       for endpoint in subnet.service_endpoints : {
#         service = endpoint.service
#       }
#     ]
#   }
# }


# output "subnet_service_endpoints" {
#   value = { for s in module.network.subnets : s.name => coalesce(s.service_endpoints, []) if length(coalesce(s.service_endpoints, [])) > 0 }
# }

# # output "subnet_service_endpoints" {
# #   value = { for s in module.network.subnets : s.name => [
# #     for sep in s.service_endpoints : {
# #       service = sep.service
# #       provisioning_state = sep.provisioning_state
# #     }
# #   ] if length(s.service_endpoints) > 0 }
# # }


output "subscriptionId" {
  value = module.network.subscriptionId
}