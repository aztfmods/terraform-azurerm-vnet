provider "azurerm" {
  features {}
}

module "region" {
  source = "github.com/aztfmods/module-azurerm-regions"

  workload    = var.workload
  environment = var.environment

  location = "westeurope"
}

module "rg" {
  source = "github.com/aztfmods/module-azurerm-rg"

  workload       = var.workload
  environment    = var.environment
  location_short = module.region.location_short
  location       = module.region.location
}

module "network" {
  source = "../../"

  workload       = var.workload
  environment    = var.environment
  location_short = module.region.location_short

  vnet = {
    location      = module.rg.group.location
    resourcegroup = module.rg.group.name
    cidr          = ["10.18.0.0/16"]
    subnets = {
      sn1 = { cidr = ["10.18.1.0/24"] }
      sn2 = { cidr = ["10.18.2.0/24"] }
    }
  }
}
