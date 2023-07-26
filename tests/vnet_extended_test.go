package main

import (
	"context"
	"testing"

	"github.com/Azure/azure-sdk-for-go/services/network/mgmt/2020-03-01/network"
	"github.com/Azure/go-autorest/autorest"
	"github.com/aztfmods/terraform-azure-vnet/shared"
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

func TestVirtualNetwork(t *testing.T) {
	t.Run("VerifyVirtualNetworkAndSubnets", func(t *testing.T) {
		t.Parallel()

		tfOpts := shared.GetTerraformOptions("../examples/complete")
		defer shared.Cleanup(t, tfOpts)
		terraform.InitAndApply(t, tfOpts)

		vnet := terraform.OutputMap(t, tfOpts, "vnet")
		virtualNetworkName, ok := vnet["name"]
		require.True(t, ok, "Virtual network name not found in terraform output")

		resourceGroupName, ok := vnet["resource_group_name"]
		require.True(t, ok, "Resource group name not found in terraform output")

		subscriptionID := terraform.Output(t, tfOpts, "subscriptionId")
		require.NotEmpty(t, subscriptionID, "Subscription ID not found in terraform output")

		authorizer, err := azure.NewAuthorizer()
		require.NoError(t, err)

		virtualNetworkClient := network.NewVirtualNetworksClient(subscriptionID)
		virtualNetworkClient.Authorizer = *authorizer

		virtualNetwork, err := virtualNetworkClient.Get(context.Background(), resourceGroupName, virtualNetworkName, "")
		require.NoError(t, err)

		t.Run("VerifyVirtualNetwork", func(t *testing.T) {
			verifyVirtualNetwork(t, virtualNetworkName, &virtualNetwork)
		})

		t.Run("VerifySubnetsExist", func(t *testing.T) {
			verifySubnetsExist(t, subscriptionID, resourceGroupName, virtualNetworkName, tfOpts, *authorizer)
		})
	})
}

func verifyVirtualNetwork(t *testing.T, virtualNetworkName string, virtualNetwork *network.VirtualNetwork) {
	t.Helper()

	require.Equal(
		t,
		virtualNetworkName,
		*virtualNetwork.Name,
		"Virtual network name does not match expected value",
	)

	require.Equal(
		t,
		"Succeeded",
		string(virtualNetwork.ProvisioningState),
		"Virtual network provisioning state is not 'Succeeded'",
	)
}

func verifySubnetsExist(t *testing.T, subscriptionID string, resourceGroupName string, virtualNetworkName string, tfOpts *terraform.Options, authorizer autorest.Authorizer) {
	t.Helper()

	subnetClient := network.NewSubnetsClient(subscriptionID)
	subnetClient.Authorizer = authorizer

	subnetsPage, err := subnetClient.ListComplete(context.Background(), resourceGroupName, virtualNetworkName)
	require.NoError(t, err)

	subnetsOutput := terraform.OutputMap(t, tfOpts, "subnets")
	require.NotEmpty(t, subnetsOutput, "Subnets output is empty")

	for _, v := range *subnetsPage.Response().Value {
		subnetName := *v.Name
		require.NotEmpty(t, subnetName, "Subnet name not found in azure response")

		require.Contains(
			t,
			subnetsOutput,
			subnetName,
			"Subnet name %s not found in Terraform output",
			subnetName,
		)

		require.NotNil(
			t,
			v.NetworkSecurityGroup,
			"No network security group association found for subnet %s", subnetName,
		)
	}
}
