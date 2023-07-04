provider "azurerm" {
  features {}
}

module "rg" {
  source = "github.com/aztfmods/terraform-azure-rg"
  version = "~> 1.0"

  environment = var.environment

  groups = {
    demo = {
      region = "westeurope"
    }
  }
}

module "network" {
  source = "github.com/aztfmods/terraform-azure-vnet"
  version = "~> 1.0"

  workload    = var.workload
  environment = var.environment

  vnet = {
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    cidr          = ["10.18.0.0/16"]
    subnets = {
      sn1 = { cidr = ["10.18.1.0/24"] }
      sn2 = { cidr = ["10.18.2.0/24"] }
    }
  }
}
