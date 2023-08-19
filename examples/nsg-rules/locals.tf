locals {
  naming = {
    # lookup outputs from the naming module
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["subnet", "network_security_group", "route_table"]
}
