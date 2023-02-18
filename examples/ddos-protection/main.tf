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

module "security" {
  source = "github.com/aztfmods/module-azurerm-security"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  ddos_plan = {
    create        = true
    location      = module.global.groups.demo.location
    resourcegroup = module.global.groups.demo.name
  }

  depends_on = [module.global]
}

module "vnet" {
  source = "../../"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  vnets = {
    location      = module.global.groups.demo.location
    resourcegroup = module.global.groups.demo.name
    cidr          = ["10.18.0.0/16"]
    dns           = ["8.8.8.8"]
    subnets = {
      sn1 = { cidr = ["10.18.1.0/24"], enforce_priv_link_policies = true }
    }

    ddos_plan = { enable = true, id = module.security.ddos_plan_id }
  }
  depends_on = [module.global]
}