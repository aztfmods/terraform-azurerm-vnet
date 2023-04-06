data "azurerm_subscription" "current" {}

# virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-demo"
  resource_group_name = var.vnet.resourcegroup
  location            = var.vnet.location
  address_space       = var.vnet.cidr

  # dynamic "ddos_protection_plan" {
  #   for_each = try(each.value.ddos_plan.enable, false) == true ? range(1) : range(0)
  #   iterator = v
  #   content {
  #     id     = each.value.ddos_plan.id
  #     enable = true
  #   }
  # }
}

# dns
resource "azurerm_virtual_network_dns_servers" "dns" {
  dns_servers        = try(var.vnet.dns_servers, [])
  virtual_network_id = azurerm_virtual_network.vnet.id
}

# subnets
resource "azurerm_subnet" "subnets" {
  for_each = {
    for subnet in local.subnets : subnet.subnet_key => subnet
  }

  name                                          = each.value.subnet_name
  resource_group_name                           = var.vnet.resourcegroup
  virtual_network_name                          = each.value.virtual_network_name
  address_prefixes                              = each.value.address_prefixes
  service_endpoints                             = each.value.endpoints
  private_link_service_network_policies_enabled = each.value.enforce_priv_link_service
  private_endpoint_network_policies_enabled     = each.value.enforce_priv_link_endpoint

  dynamic "delegation" {
    for_each = each.value.delegations

    content {
      name = delegation.key

      service_delegation {
        name    = delegation.value.name
        actions = try(lookup(delegation.value, "service_actions", []), [])
      }
    }
  }
}
 
# nsg's
resource "azurerm_network_security_group" "nsg" {
  for_each = {
    for subnet in local.subnets : subnet.subnet_key => subnet
  }

  name                = each.value.nsg_name
  resource_group_name = var.vnet.resourcegroup
  location            = each.value.location

  dynamic "security_rule" {
    for_each = each.value.rules

    content {
      name                         = security_rule.value.name
      priority                     = security_rule.value.priority
      direction                    = security_rule.value.direction
      access                       = security_rule.value.access
      protocol                     = security_rule.value.protocol
      description                  = lookup(security_rule.value, "description", null)
      source_port_range            = lookup(security_rule.value, "source_port_range", null)
      source_port_ranges           = lookup(security_rule.value, "source_port_ranges", null)
      destination_port_range       = lookup(security_rule.value, "destination_port_range", null)
      destination_port_ranges      = lookup(security_rule.value, "destination_port_ranges", null)
      source_address_prefix        = lookup(security_rule.value, "source_address_prefix", null)
      source_address_prefixes      = lookup(security_rule.value, "source_address_prefixes", null)
      destination_address_prefix   = lookup(security_rule.value, "destination_address_prefix", null)
      destination_address_prefixes = lookup(security_rule.value, "destination_address_prefixes", null)
    }
  }
}

# nsg associations
resource "azurerm_subnet_network_security_group_association" "nsg_as" {
  for_each = {
    for assoc in local.subnets : assoc.subnet_key => assoc
  }

  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}
