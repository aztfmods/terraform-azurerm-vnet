module "vnet" {
  source = "../../"
  vnets = {
    vnet1 = {
      cidr          = ["10.18.0.0/16"]
      dns           = ["8.8.8.8"]
      location      = "westeurope"
      resourcegroup = "rg-network-weeu"
      subnets = {
        sn1 = {
          cidr = ["10.18.1.0/24"]
          rules = [
            { name = "myhttps", priority = 100, direction = "Inbound", access = "Allow", protocol = "Tcp", source_port_range = "*", destination_port_range = "443", source_address_prefix = "10.151.1.0/24", destination_address_prefix = "*" },
            { name = "mysql", priority = 200, direction = "Inbound", access = "Allow", protocol = "Tcp", source_port_range = "*", destination_port_range = "3306", source_address_prefix = "10.0.0.0/24", destination_address_prefix = "*" }
          ]
        }
      }
    }

    vnet2 = {
      cidr          = ["10.19.0.0/16"]
      location      = "eastus2"
      resourcegroup = "rg-network-eus2"
      subnets = {
        sn1 = { cidr = ["10.19.1.0/24"], enforce_priv_link_policies = true }
        sn2 = { cidr = ["10.19.2.0/24"] }
      }
    }
  }
}