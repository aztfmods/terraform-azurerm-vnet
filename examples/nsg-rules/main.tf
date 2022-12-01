provider "azurerm" {
  features {}
}

locals {
  naming = {
    company = "cn"
    env     = "p"
    region  = "weu"
  }
}

module "global" {
  source = "github.com/aztfmods/module-azurerm-global"
  rgs = {
    network = {
      name     = "rg-${local.naming.company}-netw-${local.naming.env}-${local.naming.region}"
      location = "westeurope"
    }
  }
}

module "vnet" {
  source = "../../"

  naming = {
    company = local.naming.company
    env     = local.naming.env
    region  = local.naming.region
  }

  vnets = {
    vnet1 = {
      cidr          = ["10.18.0.0/16"]
      location      = module.global.groups.network.location
      resourcegroup = module.global.groups.network.name
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
  }
  depends_on = [module.global]
}