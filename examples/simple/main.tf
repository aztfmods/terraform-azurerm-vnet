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
    demo = {
      location      = module.global.groups.demo.location
      resourcegroup = module.global.groups.demo.name
      cidr          = ["10.18.0.0/16"]
      subnets = {
        demo = {
          cidr = ["10.18.1.0/24"]
          # delegations = {
          #   databricks = { name = "Microsoft.Databricks/workspaces" }
          # }
        }
      }
    }
  }
  depends_on = [module.global]
}