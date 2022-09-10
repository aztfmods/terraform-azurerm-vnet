module "vnet" {
  source = "../../"
  vnets = {
    vnet1 = {
      cidr          = ["10.18.0.0/16"]
      dns           = ["8.8.8.8"]
      location      = "westeurope"
      resourcegroup = "rg-network-weeu"
      subnets = {
        sn1 = {
          cidr = ["10.18.1.0/24"]
        }
      }
    }

    vnet2 = {
      cidr          = ["10.19.0.0/16"]
      location      = "eastus2"
      resourcegroup = "rg-network-eus2"
      subnets = {
        sn1 = { cidr = ["10.19.1.0/24"], enforce_priv_link_policies = true }
        sn2 = { cidr = ["10.19.2.0/24"] }
      }
    }
  }
}