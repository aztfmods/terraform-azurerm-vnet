package test

import (
	"context"
	"testing"

	"github.com/Azure/azure-sdk-for-go/profiles/latest/network/mgmt/network"
	"github.com/Azure/go-autorest/autorest/azure/auth"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformVnetModuleOutputsExist(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/simple",
		NoColor:      true,
		Parallelism:  2,
	}

	// defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	vnetOutput := terraform.Output(t, terraformOptions, "vnets")
	subnetOutput := terraform.Output(t, terraformOptions, "subnets")

	assert.NotEmpty(t, vnetOutput)
	assert.NotEmpty(t, subnetOutput)
}

func TestVirtualNetworkExists(t *testing.T) {
	resourceGroupName := "rg-cn-demo-p-weu"
	virtualNetworkName := "vnet-demo"

	authorizer, err := auth.NewAuthorizerFromCLI()
	if err != nil {
		t.Fatalf("failed to get authorizer: %s", err)
	}

	virtualNetworkClient := network.NewVirtualNetworksClient("cb3cf69c-4cb7-4e42-8fd8-1aae3624f329")
	virtualNetworkClient.Authorizer = authorizer

	virtualNetwork, err := virtualNetworkClient.Get(context.Background(), resourceGroupName, virtualNetworkName, "")
	if err != nil {
		t.Fatalf("failed to get virtual network: %s", err)
	}

	assert.Equal(t, virtualNetworkName, *virtualNetwork.Name)
}

func TestSubnetExists(t *testing.T) {
	resourceGroupName := "rg-cn-demo-p-weu"
	virtualNetworkName := "vnet-demo"
	subnetName := "sn-cn-sn1-p-weu"

	authorizer, err := auth.NewAuthorizerFromCLI()
	if err != nil {
		t.Fatalf("failed to get authorizer: %s", err)
	}

	virtualNetworkClient := network.NewVirtualNetworksClient("cb3cf69c-4cb7-4e42-8fd8-1aae3624f329")
	virtualNetworkClient.Authorizer = authorizer

	subnetClient := network.NewSubnetsClient("cb3cf69c-4cb7-4e42-8fd8-1aae3624f329")
	subnetClient.Authorizer = authorizer

	subnet, err := subnetClient.Get(context.Background(), resourceGroupName, virtualNetworkName, subnetName, "")
	if err != nil {
		t.Fatalf("failed to get subnet: %s", err)
	}

	assert.Equal(t, subnetName, *subnet.Name)
}

// .TODO - create seperate function azure cli auth + get subscription etc
