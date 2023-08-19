# Virtual Network

This terraform module simplifies the process of creating and managing virtual network resources on azure with configurable options for network topology, subnets, security groups, and more to ensure a secure and efficient environment for resource communication in the cloud.

## Goals

The main objective is to create a more logic data structure, achieved by combining and grouping related resources together in a complex object.

The structure of the module promotes reusability. It's intended to be a repeatable component, simplifying the process of building diverse workloads and platform accelerators consistently.

A primary goal is to utilize keys and values in the object that correspond to the REST API's structure. This enables us to carry out iterations, increasing its practical value as time goes on.

A last key goal is to separate logic from configuration in the module, thereby enhancing its scalability, ease of customization, and manageability.

## Features

- an individual network security group for each subnet, with the ability to handle multiple rules
- support for multiple service endpoints and delegations, including actions
- utilization of terratest for robust validation.
- route table support with multiple user defined routes

The below examples shows the usage when consuming the module:

## Usage: simple

```hcl
module "network" {
  source = "github.com/aztfmods/terraform-azure-vnet?ref=v1.18.0"

  naming = local.naming

  vnet = {
    name          = module.naming.virtual_network.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    cidr          = ["10.18.0.0/16"]

    subnets = {
      sn1 = { cidr = ["10.18.1.0/24"] }
      sn2 = { cidr = ["10.18.2.0/24"] }
    }
  }
}
```

## Usage: endpoints

```hcl
module "network" {
  source = "github.com/aztfmods/terraform-azure-vnet?ref=v1.18.0"

  naming = local.naming

  vnet = {
    name          = module.naming.virtual_network.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
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
  source = "github.com/aztfmods/terraform-azure-vnet?ref=v1.18.0"

  naming = local.naming

  vnet = {
    name          = module.naming.virtual_network.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.group.demo.name
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
  source = "github.com/aztfmods/terraform-azure-vnet?ref=v1.18.0"

  naming = local.naming

  vnet = {
    name          = module.naming.virtual_network.name
    cidr          = ["10.18.0.0/16"]
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

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
  source = "github.com/aztfmods/terraform-azure-vnet?ref=v1.18.0"

  naming = local.naming

  vnet = {
    name          = module.naming.virtual_network.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
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
    }
  }
}
```

## Usage: multiple

```hcl
module "network" {
  source = "../../"

  for_each = local.vnets

  naming = local.naming
  vnet   = each.value
}

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
            "Microsoft.Storage",
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
            "Microsoft.Sql"
          ]
        }
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
| `naming` | contains naming convention | string | yes |

## Outputs

| Name | Description |
| :-- | :-- |
| `vnet` | contains all vnet configuration |
| `subnets` | contains all subnets configuration |
| `subscriptionId` | contains the current subsriptionId |
| `merged_ids` | contains all resource id's specified within the module |

## Testing

The github repository utilizes a Makefile to conduct tests to evaluate and validate different configurations of the module. These tests are designed to enhance its stability and reliability.

Before initiating the tests, please ensure that both go and terraform are properly installed on your system.

The [Makefile](Makefile) incorporates three distinct test variations. The first one, a local deployment test, is designed for local deployments and allows the overriding of workload and environment values. It includes additional checks and can be initiated using the command ```make test_local```.

The second variation is an extended test. This test performs additional validations and serves as the default test for the module within the github workflow.

The third variation allows for specific deployment tests. By providing a unique test name in the github workflow, it overrides the default extended test, executing the specific deployment test instead.

Each of these tests contributes to the robustness and resilience of the module. They ensure the module performs consistently and accurately under different scenarios and configurations.

## Authors

Module is maintained by [Dennis Kool](https://github.com/dkooll).

## License

MIT Licensed. See [LICENSE](https://github.com/aztfmods/terraform-azure-vnet/blob/main/LICENSE) for full details.

## Reference

- [Documentation](https://learn.microsoft.com/en-us/azure/virtual-network/)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/virtual-network/)
- [Rest Api Specs](https://github.com/Azure/azure-rest-api-specs/blob/main/specification/network/resource-manager/Microsoft.Network/stable/2023-04-01/virtualNetwork.json)
