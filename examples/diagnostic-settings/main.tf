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

module "logging" {
  source = "github.com/aztfmods/module-azurerm-law"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  laws = {
    diags = {
      location      = module.global.groups.demo.location
      resourcegroup = module.global.groups.demo.name
      sku           = "PerGB2018"
      retention     = 30
    }
  }
  depends_on = [module.global]
}

module "vnet" {
  source = "../../"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  vnets = {
    demo = {
      location      = module.global.groups.demo.location
      resourcegroup = module.global.groups.demo.name
      cidr          = ["10.18.0.0/16"]
      dns           = ["8.8.8.8"]
      subnets = {
        sn1 = { cidr = ["10.18.1.0/24"] }
        sn2 = { cidr = ["10.18.2.0/24"] }
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