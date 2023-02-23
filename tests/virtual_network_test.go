package tests

import (
	"context"
	"testing"

	"github.com/Azure/azure-sdk-for-go/services/network/mgmt/2020-03-01/network"
	"github.com/Azure/go-autorest/autorest"
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

const resourceGroupName = "rg-cn-demo-p-weu"

func TestVirtualNetwork(t *testing.T) {
	t.Parallel()

	tfOpts := &terraform.Options{
		TerraformDir: "../examples/simple",
		NoColor:      true,
		Parallelism:  2,
	}

	// defer terraform.Destroy(t, tfOpts)
	terraform.InitAndApply(t, tfOpts)

	vnets := terraform.OutputMap(t, tfOpts, "vnets")
	virtualNetworkName := vnets["name"]
	subscriptionID := terraform.Output(t, tfOpts, "subscriptionId")
	require.NotEmpty(t, virtualNetworkName)

	authorizer, err := azure.NewAuthorizer()
	require.NoError(t, err)

	virtualNetworkClient := newVirtualNetworkClient(subscriptionID, *authorizer)
	virtualNetwork, err := virtualNetworkClient.Get(context.Background(), resourceGroupName, virtualNetworkName, "")
	require.NoError(t, err)

	require.Equal(t, virtualNetworkName, *virtualNetwork.Name)
	require.Equal(t, "Succeeded", string(virtualNetwork.ProvisioningState))

	checkSubnets(t, subscriptionID, resourceGroupName, virtualNetworkName, tfOpts, *authorizer)
}

func checkSubnets(t *testing.T, subscriptionID string, resourceGroupName string, virtualNetworkName string, tfOpts *terraform.Options, authorizer autorest.Authorizer) {
	subnetClient := network.NewSubnetsClient(subscriptionID)
	subnetClient.Authorizer = authorizer

	subnetsPage, err := subnetClient.ListComplete(context.Background(), resourceGroupName, virtualNetworkName)
	require.NoError(t, err)

	subnetsOutput := terraform.OutputMap(t, tfOpts, "subnets")
	require.NotEmpty(t, subnetsOutput)

	for _, v := range *subnetsPage.Response().Value {
		subnetName := *v.Name
		require.Contains(t, subnetsOutput, subnetName)
	}
}

func newVirtualNetworkClient(subscriptionID string, authorizer autorest.Authorizer) *network.VirtualNetworksClient {
	virtualNetworkClient := network.NewVirtualNetworksClient(subscriptionID)
	virtualNetworkClient.Authorizer = authorizer
	return &virtualNetworkClient
}
