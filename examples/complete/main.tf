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
  source = "../.."

  workload       = var.workload
  environment    = var.environment
  location_short = module.region.location_short

  vnet = {
    location      = module.rg.group.location
    resourcegroup = module.rg.group.name
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
          databricks = {
            name = "Microsoft.Databricks/workspaces"
          }
        }
      }
      sn3 = {
        cidr = ["10.18.3.0/24"]
        routes = {
          udr1 = {
            address_prefix = "Storage"
            next_hop_type  = "Internet"
          }
        }
      }
      sn4 = {
        cidr = ["10.18.4.0/24"]
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
}
