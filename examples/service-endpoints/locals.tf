locals {
  naming = {
    virtual_network        = module.naming.virtual_network.name
    subnet                 = module.naming.subnet.name
    network_security_group = module.naming.network_security_group.name
    route_table            = module.naming.route_table.name
  }
}
