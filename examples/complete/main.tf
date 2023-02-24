provider "azurerm" {
  features {}
}

module "global" {
  source = "github.com/aztfmods/module-azurerm-global"

  company = "cn"
  env     = "p"
  region  = "weu"

  rgs = {
    demotest = { location = "westeurope" }
  }
}

module "vnet" {
  source = "../.."

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  vnets = {
    location      = module.global.groups.demotest.location
    resourcegroup = module.global.groups.demotest.name
    cidr          = ["10.18.0.0/16"]
    subnets = {
      sn1 = {
        cidr = ["10.18.1.0/24"]
        endpoints = [
          "Microsoft.Storage",
          "Microsoft.Sql"
        ]
      }
      sn2 = {
        cidr = ["10.18.2.0/24"]
        delegations = {
          databricks = { name = "Microsoft.Databricks/workspaces" }
        }
      }
      sn3 = {
        cidr = ["10.18.3.0/24"]
        rules = [
          {
            name                       = "myhttps"
            priority                   = 100
            direction                  = "Inbound"
            access                     = "Allow"
            protocol                   = "Tcp"
            source_port_range          = "*"
            destination_port_range     = "443"
            source_address_prefix      = "10.151.1.0/24"
            destination_address_prefix = "*"
          },
          {
            name                       = "mysql"
            priority                   = 200
            direction                  = "Inbound"
            access                     = "Allow"
            protocol                   = "Tcp"
            source_port_range          = "*"
            destination_port_range     = "3306"
            source_address_prefix      = "10.0.0.0/24"
            destination_address_prefix = "*"
          }
        ]
      }
    }
  }
  depends_on = [module.global]
}