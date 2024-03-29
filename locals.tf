locals {
  subnets = flatten([
    for subnet_key, subnet in try(var.vnet.subnets, {}) : {

      subnet_key                 = subnet_key
      virtual_network_name       = azurerm_virtual_network.vnet.name
      address_prefixes           = subnet.cidr
      endpoints                  = try(subnet.endpoints, [])
      enforce_priv_link_service  = try(subnet.enforce_priv_link_service, false)
      enforce_priv_link_endpoint = try(subnet.enforce_priv_link_endpoint, false)
      delegations                = try(subnet.delegations, [])
      rules                      = try(subnet.rules, {})
      subnet_name                = "${var.naming.subnet}-${subnet_key}"
      nsg_name                   = "${var.naming.network_security_group}-${subnet_key}"
      location                   = var.vnet.location
      rt_name                    = "${var.naming.route_table}-${subnet_key}"
      routes                     = try(subnet.routes, {})
    }
  ])
}
