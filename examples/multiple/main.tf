provider "azurerm" {
  features {}
}

module "naming" {
  source = "github.com/aztfmods/terraform-azure-naming"

  suffix = ["demo", "dev"]
}

module "rg" {
  source = "github.com/aztfmods/terraform-azure-rg"

  groups = {
    demo = {
      name   = module.naming.resource_group.name
      region = "westeurope"
    }
  }
}

module "network" {
  source = "../../"

  for_each = local.vnets

  naming = local.naming
  vnet   = each.value
}
