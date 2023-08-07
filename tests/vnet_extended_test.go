package main

import (
	"context"
	"strings"
	"testing"
	"github.com/stretchr/testify/assert"
	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/network/armnetwork"
	"github.com/aztfmods/terraform-azure-vnet/shared"
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

		cred, err := azidentity.NewDefaultAzureCredential(nil)
		if err != nil {
			t.Fatalf("failed to get credentials: %+v", err)
		}

		virtualNetworkClient, err := armnetwork.NewVirtualNetworksClient(subscriptionID, cred, nil)
		if err != nil {
			t.Fatalf("failed to create virtual network client: %+v", err)
		}

		virtualNetworkResponse, err := virtualNetworkClient.Get( context.Background(), resourceGroupName, virtualNetworkName, nil)
		if err != nil {
			t.Fatalf("failed to get virtual network: %+v", err)
		}

		virtualNetwork := virtualNetworkResponse.VirtualNetwork

		t.Run("VerifyVirtualNetwork", func(t *testing.T) {
			verifyVirtualNetwork(t, virtualNetworkName, &virtualNetwork)
		})

		t.Run("VerifySubnetsExist", func(t *testing.T) {
			verifySubnetsExist(t, subscriptionID, resourceGroupName, virtualNetworkName, tfOpts)
		})
	})
}

func verifyVirtualNetwork(t *testing.T, virtualNetworkName string, virtualNetwork *armnetwork.VirtualNetwork) {
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
		string(*virtualNetwork.Properties.ProvisioningState),
		"Virtual network provisioning state is not 'Succeeded'",
	)

	require.True(
		t,
		strings.HasPrefix(virtualNetworkName, "vnet"),
		"Virtual network name does not begin with the right abbreviation",
	)
}

func verifySubnetsExist(t *testing.T, subscriptionID string, resourceGroupName string, virtualNetworkName string, tfOpts *terraform.Options) {
	t.Helper()

	cred, err := azidentity.NewDefaultAzureCredential(nil)
	if err != nil {
		t.Fatalf("failed to get credentials: %+v", err)
	}

	subnetClient, err := armnetwork.NewSubnetsClient(subscriptionID, cred, nil)
	if err != nil {
		t.Fatalf("failed to create subnet client: %+v", err)
	}

	pager := subnetClient.NewListPager(resourceGroupName, virtualNetworkName, nil)

	subnetsOutput := terraform.OutputMap(t, tfOpts, "subnets")
	assert.NotEmpty(t, subnetsOutput, "Subnets output is empty")

	for {
		page, err := pager.NextPage(context.Background())
		if err != nil {
			t.Fatalf("Failed to list subnets: %v", err)
		}

		for _, subnet := range page.Value {
			subnetName := *subnet.Name
			assert.NotEmpty(
				t,
				subnetName,
				"Subnet name not found in azure response",
			)

			assert.Contains(
				t,
				subnetsOutput,
				subnetName,
				"Subnet name %s not found in Terraform output",
				subnetName,
			)

			assert.NotNil(
				t,
				subnet.Properties.NetworkSecurityGroup,
				"No network security group association found for subnet %s",
				subnetName,
			)

			//FIX: validate terraform output instead of sdk response
			assert.True(
				t,
				strings.HasPrefix(*subnet.Name, "snet"),
				"Subnet name %s does not begin with the right abbreviation",
				subnetName,
			)
		}

		if page.NextLink == nil || len(*page.NextLink) == 0 {
			break
		}
	}
}
