locals {
  network_subnets = flatten([
    for network_key, network in var.vnets : [
      for subnet_key, subnet in try(network.subnets, {}) : {

        network_key                = network_key
        subnet_key                 = subnet_key
        address_prefixes           = subnet.cidr
        rg_name                    = azurerm_resource_group.rg[network_key].name
        subnet_name                = "sn-${var.env}-${network_key}-${subnet_key}"
        nsg_name                   = "nsg-${var.env}-${network_key}-${subnet_key}"
        location                   = network.location
        endpoints                  = try(subnet.endpoints, [])
        rules                      = try(subnet.rules, {})
        delegations                = try(subnet.delegations, [])
        virtual_network_name       = azurerm_virtual_network.vnets[network_key].name
        enforce_priv_link_service  = try(subnet.enforce_priv_link_service, false)
        enforce_priv_link_endpoint = try(subnet.enforce_priv_link_endpoint, false)
      }
    ]
  ])
}