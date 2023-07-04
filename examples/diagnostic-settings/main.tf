provider "azurerm" {
  features {}
}

module "logging" {
  source = "github.com/aztfmods/terraform-azure-law?ref=v1.6.0"

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

module "network" {
  source = "github.com/aztfmods/terraform-azure-vnet?ref=v1.13.0"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  vnet = {
    location      = module.global.groups.demo.location
    resourcegroup = module.global.groups.demo.name
    cidr          = ["10.18.0.0/16"]
    dns           = ["8.8.8.8"]
    subnets = {
      sn1 = { cidr = ["10.18.1.0/24"] }
      sn2 = { cidr = ["10.18.2.0/24"] }
    }
  }
  depends_on = [module.global]
}

module "diagnostic_settings" {
  source = "github.com/aztfmods/terraform-azure-diags?ref=v1.0.0"
  count  = length(module.vnet.merged_ids)

  resource_id           = element(module.vnet.merged_ids, count.index)
  logs_destinations_ids = [lookup(module.logging.laws.diags, "id", null)]
}
