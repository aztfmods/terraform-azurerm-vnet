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

module "logging" {
  source = "github.com/aztfmods/module-azurerm-law"

  naming = {
    company = local.naming.company
    env     = local.naming.env
    region  = local.naming.region
  }

  laws = {
    diags = {
      location      = module.global.groups.network.location
      resourcegroup = module.global.groups.network.name
      sku           = "PerGB2018"
      retention     = 30
    }
  }
  depends_on = [module.global]
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
      location      = module.global.groups.network.location
      resourcegroup = module.global.groups.network.name
      cidr          = ["10.18.0.0/16"]
      dns           = ["8.8.8.8"]
      subnets = {
        sn1 = { cidr = ["10.18.1.0/24"]}
        sn2 = { cidr = ["10.18.2.0/24"]}
      }
    }
  }
  depends_on = [module.global]
}

module "diagnostic_settings" {
  source = "github.com/aztfmods/module-azurerm-diags"
  count  = length(module.vnet.merged_ids)

  resource_id           = element(module.vnet.merged_ids, count.index)
  logs_destinations_ids = [lookup(module.logging.laws.diags, "id", null)]
}