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
    netw = {
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
    demo = {
      location      = module.global.groups.acr.location
      resourcegroup = module.global.groups.acr.name
      cidr          = ["10.18.0.0/16"]
      dns           = ["8.8.8.8"]
      subnets = {
        sn1 = { cidr = ["10.18.1.0/24"], enforce_priv_link_policies = true}
      }
    }
  }
  depends_on = [module.global]
}