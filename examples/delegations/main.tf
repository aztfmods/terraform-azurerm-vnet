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
      subnets = {
        sn1 = {
          cidr = ["10.18.1.0/24"]
          delegations = {
            databricks = { name = "Microsoft.Databricks/workspaces" }
            netapp     = { name = "Microsoft.Netapp/volumes" }
            cosmosdb   = { name = "Microsoft.AzureCosmosDB/clusters" }
          }
        }
      }
    }
  }
  depends_on = [module.global]
}