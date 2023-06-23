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
      sn1 = {
        cidr = ["10.18.1.0/24"]
        delegations = {
          sql = {
            name = "Microsoft.Sql/managedInstances"
            service_actions = [
              "Microsoft.Network/virtualNetworks/subnets/join/action",
              "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
              "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
            ]
          }
        }
      }
      sn2 = {
        cidr = ["10.18.2.0/24"]
        delegations = {
          web = { name = "Microsoft.Web/serverFarms" }
        }
      }
    }
  }
}
