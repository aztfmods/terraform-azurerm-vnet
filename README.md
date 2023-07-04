# Virtual Network

This terraform module simplifies the process of creating and managing virtual network resources on azure with configurable options for network topology, subnets, security groups, and more to ensure a secure and efficient environment for resource communication in the cloud.

## Goals

The main objective is to create a more logic data structure, achieved by combining and grouping related resources together in a complex object.

The structure of the module promotes reusability. It's intended to be a repeatable component, simplifying the process of building diverse workloads and platform accelerators consistently.

A key objective is to employ keys and values within the object that align with the REST API's structure. This paves the way for multiple iterations and expansions, enriching its practical application over time.

## Features

- network security group on each subnet with multiple rules
- service endpoints and delegations
- terratest for validation
- diagnostic logs integration
- ddos protection plan integration
- route table support with multiple user defined routes

The below examples shows the usage when consuming the module:

## Usage: simple

```hcl
module "network" {
  source = "github.com/aztfmods/module-azurerm-vnet"

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
      }
    }
  }
}
```

## Usage: endpoints

```hcl
module "network" {
  source = "github.com/aztfmods/module-azurerm-vnet"

  workload       = var.workload
  environment    = var.environment
  location_short = module.region.location_short

  vnet = {
    location      = module.rg.group.location
    resourcegroup = module.rg.group.name
    cidr          = ["10.18.0.0/16"]
    subnets = {
      demo = {
        cidr = ["10.18.3.0/24"]
        endpoints = [
          "Microsoft.Storage",
          "Microsoft.Sql"
        ]
      }
    }
  }
}
```

## Usage: delegations

```hcl
module "network" {
  source = "github.com/aztfmods/module-azurerm-vnet"

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
    }
  }
}
```

## Usage: nsg rules

```hcl
module "network" {
  source = "github.com/aztfmods/module-azurerm-vnet"

  workload       = var.workload
  environment    = var.environment
  location_short = module.region.location_short

  vnet = {
    cidr          = ["10.18.0.0/16"]
    location      = module.rg.group.location
    resourcegroup = module.rg.group.name
    subnets = {
      sn1 = {
        cidr = ["10.18.1.0/24"]
        rules = [
          { name = "myhttps", priority = 100, direction = "Inbound", access = "Allow", protocol = "Tcp", source_port_range = "*", destination_port_range = "443", source_address_prefix = "10.151.1.0/24", destination_address_prefix = "*" },
          { name = "mysql", priority = 200, direction = "Inbound", access = "Allow", protocol = "Tcp", source_port_range = "*", destination_port_range = "3306", source_address_prefix = "10.0.0.0/24", destination_address_prefix = "*" }
        ]
      }
    }
  }
}
```

## Usage: routes

```hcl
module "network" {
  source = "github.com/aztfmods/module-azurerm-vnet"

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
        routes = {
          udr1 = {
            address_prefix = "Storage"
            next_hop_type  = "Internet"
          }
          udr2 = {
            address_prefix = "SqlManagement"
            next_hop_type  = "Internet"
          }
        }
      }
      sn2 = {
        cidr = ["10.18.2.0/24"]
      }
    }
  }
}
````
## Resources

| Name | Type |
| :-- | :-- |
| [azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_dns_servers](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_dns_servers) | resource |
| [azurerm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_network_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_subnet_network_security_group_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_route_table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_subnet_route_table_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |

## Inputs

| Name | Description | Type | Required |
| :-- | :-- | :-- | :-- |
| `vnets` | describes vnet related configuration | object | yes |
| `company` | contains the company name used, for naming convention | string | yes |
| `region` | contains the shortname of the region, used for naming convention | string | yes |
| `env` | contains shortname of the environment used for naming convention | string | yes |

## Outputs

| Name | Description |
| :-- | :-- |
| `vnet` | contains all vnet configuration |
| `subnets` | contains all subnets configuration |
| `subscriptionId` | contains the current subsriptionId |
| `merged_ids` | contains all resource id's specified within the module |

## Testing
This GitHub repository features a [Makefile](./Makefile) tailored for testing various configurations. Each test target corresponds to different example use cases provided within the repository.

Before running these tests, ensure that both Go and Terraform are installed on your system. To execute a specific test, use the following command ```make <test-target>```

## Authors

Module is maintained by [Dennis Kool](https://github.com/dkooll) with help from [these awesome contributors](https://github.com/aztfmods/module-azurerm-vnet/graphs/contributors).

## License

MIT Licensed. See [LICENSE](https://github.com/aztfmods/module-azurerm-vnet/blob/main/LICENSE) for full details.

## Reference

- [Virtual Network Documentation - Microsoft docs](https://learn.microsoft.com/en-us/azure/virtual-network/)
- [Virtual Network Rest Api - Microsoft docs](https://learn.microsoft.com/en-us/rest/api/virtual-network/)
