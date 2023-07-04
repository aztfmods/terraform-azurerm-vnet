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
- route table support with multiple user defined routes

The below examples shows the usage when consuming the module:

## [Usage: simple](examples/simple/main.tf)

```hcl
module "network" {
  source = "github.com/aztfmods/terraform-azure-vnet?ref=v1.13.0"

  workload    = var.workload
  environment = var.environment

  vnet = {
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    cidr          = ["10.18.0.0/16"]
    subnets = {
      sn1 = {
        cidr = ["10.18.1.0/24"]
      }
    }
  }
}
```

## [Usage: endpoints](examples/service-endpoints/main.tf)

```hcl
module "network" {
  source = "github.com/aztfmods/terraform-azure-vnet?ref=v1.13.0"

  workload    = var.workload
  environment = var.environment

  vnet = {
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

## [Usage: delegations](examples/delegations/main.tf)

```hcl
module "network" {
  source = "github.com/aztfmods/terraform-azure-vnet?ref=v1.13.0"

  workload    = var.workload
  environment = var.environment

  vnet = {
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
      sn2 = {
        cidr = ["10.18.2.0/24"]
        delegations = {
          web = { name = "Microsoft.Web/serverFarms" }
        }
      }
    }
  }
}
```

## [Usage: nsg rules](examples/nsg-rules/main.tf)

```hcl
module "network" {
  source = "github.com/aztfmods/terraform-azure-vnet?ref=v1.13.0"

  workload    = var.workload
  environment = var.environment

  vnet = {
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

## [Usage: routes](examples/routes/main.tf)

```hcl
module "network" {
  source = "github.com/aztfmods/terraform-azure-vnet?ref=v1.13.0"

  workload    = var.workload
  environment = var.environment

  vnet = {
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

This GitHub repository is equipped with a Makefile designed to run a series of tests, each of which corresponds to different example use cases provided within the repository.

The testing process is crafted to assess and validate various configurations, contributing to the stability and reliability of the module.
Before running these tests, ensure that both Go and Terraform are installed on your system.

The Makefile includes three distinct test variations:

```local```<br>
this test is ideal for local deployments, as it allows overriding the workload and environment values. It performs additional tests. The command for executing this test is ```make test_local```.

```extended```<br>
this test is utilized for additional checks in the github workflow, making it the default test for the module.

Both tests are using the complete example, but it also possible to accommodate specific use cases. By providing a specific test name in the gitHub workflow, the test executes that particular deployment test and overrides the default extended one.

Each of these tests contribute to the robustness and resilience of the module, helping to ensure that it performs consistently and accurately under various scenarios and configurations.

## Authors

Module is maintained by [Dennis Kool](https://github.com/dkooll) with help from [these awesome contributors](https://github.com/aztfmods/module-azurerm-vnet/graphs/contributors).

## License

MIT Licensed. See [LICENSE](https://github.com/aztfmods/module-azurerm-vnet/blob/main/LICENSE) for full details.

## Reference

- [Virtual Network Documentation - Microsoft docs](https://learn.microsoft.com/en-us/azure/virtual-network/)
- [Virtual Network Rest Api - Microsoft docs](https://learn.microsoft.com/en-us/rest/api/virtual-network/)
