provider "azurerm" {
  features {}
}

module "logging" {
  source = "github.com/aztfmods/module-azurerm-law"
  laws = {
    diags = {
      location      = "westeurope"
      resourcegroup = "rg-law-weeu"
      sku           = "PerGB2018"
      retention     = 30
    }
  }
}

module "network" {
  source = "../.."
  vnets = {
    vnet1 = {
      cidr          = ["10.19.0.0/16"]
      location      = "eastus2"
      resourcegroup = "rg-network-eus2"
      subnets = {
        sn1 = { cidr = ["10.19.1.0/24"] }
      }
    }
  }
}

module "diagnostic_settings" {
  source = "github.com/aztfmods/module-azurerm-diags"
  count  = length(module.network.merged_ids)

  resource_id           = element(module.network.merged_ids, count.index)
  logs_destinations_ids = [lookup(module.logging.laws.diags, "id", null)]
}