provider "azurerm" {
  features {}
}

module "rg" {
  source = "github.com/aztfmods/module-azurerm-rg"

  workload    = var.workload
  environment = var.environment
  region      = "westeurope"
}

module "network" {
  source = "../../"

  workload    = var.workload
  environment = var.environment

  vnet = {
    location      = module.rg.group.default.location
    resourcegroup = module.rg.group.default.name
    cidr          = ["10.18.0.0/16"]
    subnets = {
      demo = {
        cidr = ["10.18.3.0/24"]
        endpoints = [
          "Microsoft.Storage",
          "Microsoft.Sql"
        ]
      }
    }
  }
}
