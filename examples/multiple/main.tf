provider "azurerm" {
  features {}
}

module "global" {
  source = "github.com/aztfmods/module-azurerm-global"

  company = "cn"
  env     = "p"
  region  = "weu"

  rgs = {
    demo = { location = "westeurope" }
  }
}

module "vnet" {
  source = "../../"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  vnets = {
    vnet1 = {
      cidr          = ["10.18.0.0/16"]
      location      = module.global.groups.demo.location
      resourcegroup = module.global.groups.demo.name
      subnets = {
        sn1 = { cidr = ["10.18.1.0/24"] }
        sn2 = { cidr = ["10.18.2.0/24"] }
      }
    }

    vnet2 = {
      cidr          = ["10.19.0.0/16"]
      location      = module.global.groups.demo.location
      resourcegroup = module.global.groups.demo.name
      subnets = {
        sn3 = { cidr = ["10.19.1.0/24"] }
        sn4 = { cidr = ["10.19.2.0/24"] }
      }
    }
  }
  depends_on = [module.global]
}