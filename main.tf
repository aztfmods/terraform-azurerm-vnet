#----------------------------------------------------------------------------------------
# Resourcegroups
#----------------------------------------------------------------------------------------

data "azurerm_resource_group" "rg" {
  for_each = var.vnets

  name = each.value.resourcegroup
}

#----------------------------------------------------------------------------------------
# vnets
#----------------------------------------------------------------------------------------

resource "azurerm_virtual_network" "vnets" {
  for_each = var.vnets

  name                = "vnet-${var.naming.company}-${each.key}-${var.naming.env}-${var.naming.region}"
  resource_group_name = data.azurerm_resource_group.rg[each.key].name
  location            = data.azurerm_resource_group.rg[each.key].location
  address_space       = each.value.cidr

  dynamic "ddos_protection_plan" {
    for_each = try(each.value.ddos_plan.enable, false) == true ? range(1) : range(0)
    iterator = v
    content {
      id     = each.value.ddos_plan.id
      enable = true
    }
  }
}

#----------------------------------------------------------------------------------------
# dns
#----------------------------------------------------------------------------------------

resource "azurerm_virtual_network_dns_servers" "dns" {
  for_each = var.vnets

  virtual_network_id = azurerm_virtual_network.vnets[each.key].id
  dns_servers        = try(each.value.dns, [])
}

#----------------------------------------------------------------------------------------
# subnets
#----------------------------------------------------------------------------------------

resource "azurerm_subnet" "subnets" {
  for_each = {
    for subnet in local.network_subnets : "${subnet.network_key}.${subnet.subnet_key}" => subnet
  }

  name                                          = each.value.subnet_name
  resource_group_name                           = each.value.rg_name
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
        name = delegation.value.name
      }
    }
  }
}

resource "time_sleep" "wait_50_seconds" {
  create_duration  = "50s"
  destroy_duration = "50s"
  depends_on       = [azurerm_subnet.subnets]
}

resource "time_sleep" "wait_50_seconds_del" {
  destroy_duration = "30s"
  depends_on       = [azurerm_subnet_network_security_group_association.nsg_as]
}

#----------------------------------------------------------------------------------------
# nsg's
#----------------------------------------------------------------------------------------

resource "azurerm_network_security_group" "nsg" {
  for_each = {
    for subnet in local.network_subnets : "${subnet.network_key}.${subnet.subnet_key}" => subnet
  }

  name                = each.value.nsg_name
  resource_group_name = each.value.rg_name
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

#----------------------------------------------------------------------------------------
# nsg subnet associations
#----------------------------------------------------------------------------------------

resource "azurerm_subnet_network_security_group_association" "nsg_as" {
  for_each = {
    for subnet in local.network_subnets : "${subnet.network_key}.${subnet.subnet_key}" => subnet
  }

  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id

  depends_on = [time_sleep.wait_50_seconds_del]
}