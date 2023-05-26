# Virtual Network

This terraform module simplifies the process of creating and managing virtual network resources on azure with configurable options for network topology, subnets, security groups, and more to ensure a secure and efficient environment for resource communication in the cloud.

The below features are made available:

- network security group on each subnet with multiple Rules:

> each subnet is fortified by a network security group with multiple rules, effectively regulating traffic and enhancing overall network security.

- service endpoint and delegation:
Leveraging service endpoints and delegations ensures secure and direct connections to Azure services, enhancing performance and security.

- terratest for validation:
Validation of different integrations is ensured by employing terratest, a robust Go library. This provides a reliable way to run tests against infrastructure code, thereby enhancing its overall robustness.

- diagnostic logs integration:
The integration of Azure's Diagnostic Logs brings valuable insights into operations, errors, and other telemetry data, enabling efficient and proactive troubleshooting.

- ddos protection plan integration:
To enhance resilience against Distributed Denial-of-Service (DDoS) attacks, Azure's DDoS Protection Plan is integrated into the setup, bolstering defenses and ensuring service availability.

- route table support with multiple user defined routes:
Supporting route tables with multiple user-defined routes allows for greater control and flexibility over network traffic paths, catering to diverse business needs.

- network security group on each subnet with multiple rules
- service endpoint, delegation
- terratest is used to validate different integrations
- diagnostic logs integration
- ddos protection plan integration
- route table support with multiple user defined routes

The below examples shows the usage when consuming the module:

## Usage: simple

```hcl
module "network" {
  source = "github.com/aztfmods/module-azurerm-vnet"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  vnet = {
    location      = module.global.groups.demo.location
    resourcegroup = module.global.groups.demo.name
    cidr          = ["10.18.0.0/16"]
    subnets = {
      sn1 = { cidr = ["10.18.1.0/24"] }
    }
  }
  depends_on = [module.global]
}
```

## Usage: endpoints

```hcl
module "network" {
  source = "github.com/aztfmods/module-azurerm-vnet"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  vnet = {
    location      = module.global.groups.demo.location
    resourcegroup = module.global.groups.demo.name
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
  depends_on = [module.global]
}
```

## Usage: delegations

```hcl
module "network" {
  source = "github.com/aztfmods/module-azurerm-vnet"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  vnet = {
    location      = module.global.groups.demo.location
    resourcegroup = module.global.groups.demo.name
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
  depends_on = [module.global]
}
```

## Usage: nsg rules

```hcl
module "network" {
  source = "github.com/aztfmods/module-azurerm-vnet"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  vnet = {
    cidr          = ["10.18.0.0/16"]
    location      = module.global.groups.demo.location
    resourcegroup = module.global.groups.demo.name
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
  depends_on = [module.global]
}
```

## Resources

| Name | Type |
| :-- | :-- |
| [azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_dns_servers](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_dns_servers) | resource |
| [azurerm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_network_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_subnet_network_security_group_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |

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
