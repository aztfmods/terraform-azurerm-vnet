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

module "security" {
  source = "github.com/aztfmods/module-azurerm-security"

  naming = {
    company = local.naming.company
    env     = local.naming.env
    region  = local.naming.region
  }

  ddos_plan = {
    create        = true
    location      = module.global.groups.network.location
    resourcegroup = module.global.groups.network.name
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
        sn1 = { cidr = ["10.18.1.0/24"], enforce_priv_link_policies = true }
      }

      ddos_plan = { enable = true, id = module.security.ddos_plan_id }
    }
  }
  depends_on = [module.global]
}