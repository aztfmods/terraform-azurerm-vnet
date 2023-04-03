package tests

import (
	"context"
	"fmt"
	"os"
	"path/filepath"
	"testing"

	"github.com/Azure/azure-sdk-for-go/services/network/mgmt/2020-03-01/network"
	"github.com/Azure/go-autorest/autorest"
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

var filesToCleanup = []string{
	".terraform",
	".terraform.lock.hcl",
	"terraform.tfstate",
	"terraform.tfstate.backup",
}

func TestApplyNoError(t *testing.T) {
	t.Parallel()

	tests := map[string]string{
		"simple":              "../examples/simple",
		"ddos-protection":     "../examples/ddos-protection",
		"diagnostic-settings": "../examples/diagnostic-settings",
		"nsg-rules":           "../examples/nsg-rules",
		"service-endpoints":   "../examples/service-endpoints",
		"delegations":         "../examples/delegations",
	}

	for name, path := range tests {
		t.Run(name, func(t *testing.T) {
			terraformOptions := &terraform.Options{
				TerraformDir: path,
				NoColor:      true,
				Parallelism:  2,
			}

			terraform.WithDefaultRetryableErrors(t, &terraform.Options{})

			defer cleanupFiles(path)
			defer func() {
				sequentialDestroy(t, terraformOptions)
				cleanupFiles(path)
			}()

			terraform.InitAndApply(t, terraformOptions)
		})
	}
}

func TestVirtualNetwork(t *testing.T) {
	t.Parallel()

	tfOpts := &terraform.Options{
		TerraformDir: "../examples/complete",
		NoColor:      true,
		Parallelism:  20,
	}

	defer func() {
		sequentialDestroy(t, tfOpts)
		cleanupFiles("../examples/complete")
	}()

	terraform.InitAndApply(t, tfOpts)

	vnet := terraform.OutputMap(t, tfOpts, "vnet")
	virtualNetworkName := vnet["name"]
	resourceGroupName := vnet["resource_group_name"]
	subscriptionID := terraform.Output(t, tfOpts, "subscriptionId")
	require.NotEmpty(t, virtualNetworkName)

	authorizer, err := azure.NewAuthorizer()
	require.NoError(t, err)

	virtualNetworkClient := network.NewVirtualNetworksClient(subscriptionID)
	virtualNetworkClient.Authorizer = *authorizer

	virtualNetwork, err := virtualNetworkClient.Get(context.Background(), resourceGroupName, virtualNetworkName, "")
	require.NoError(t, err)

	verifyVirtualNetwork(t, virtualNetworkName, &virtualNetwork)
	verifySubnetsExist(t, subscriptionID, resourceGroupName, virtualNetworkName, tfOpts, *authorizer)
}

func verifyVirtualNetwork(t *testing.T, virtualNetworkName string, virtualNetwork *network.VirtualNetwork) {
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
	subnetClient := network.NewSubnetsClient(subscriptionID)
	subnetClient.Authorizer = authorizer

	subnetsPage, err := subnetClient.ListComplete(context.Background(), resourceGroupName, virtualNetworkName)
	require.NoError(t, err)

	subnetsOutput := terraform.OutputMap(t, tfOpts, "subnets")
	require.NotEmpty(t, subnetsOutput)

	for _, v := range *subnetsPage.Response().Value {
		subnetName := *v.Name

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

func cleanupFiles(dir string) {
	for _, file := range filesToCleanup {
		filePath := filepath.Join(dir, file)
		if err := os.RemoveAll(filePath); err != nil {
			fmt.Printf("Failed to remove %s: %v\n", filePath, err)
		}
	}
}

// api limitations https://github.com/hashicorp/terraform-provider-azurerm/issues/17565
func sequentialDestroy(t *testing.T, tfOpts *terraform.Options) {
	tfOpts.Parallelism = 1
	terraform.Destroy(t, tfOpts)
}
