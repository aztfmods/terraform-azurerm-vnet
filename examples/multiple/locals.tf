locals {
  vnets = {
    vnet1 = {
      name          = join("-", [module.naming.virtual_network.name, "001"])
      location      = module.rg.groups.demo.location
      resourcegroup = module.rg.groups.demo.name
      cidr          = ["10.18.0.0/16"]

      subnets = {
        sql = {
          cidr = ["10.18.1.0/24"]
          endpoints = [
            "Microsoft.Sql"
          ]
        },
        ws = {
          cidr = ["10.18.2.0/24"]
          delegations = {
            databricks = {
              name = "Microsoft.Databricks/workspaces"
            }
          }
        }
      }
    },
    vnet2 = {
      name          = join("-", [module.naming.virtual_network.name, "002"])
      location      = module.rg.groups.demo.location
      resourcegroup = module.rg.groups.demo.name
      cidr          = ["10.20.0.0/16"]

      subnets = {
        plink = {
          cidr = ["10.20.1.0/24"]
          endpoints = [
            "Microsoft.Storage",
          ]
        }
      }
    }
  }
}

locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["subnet", "network_security_group", "route_table"]
}
