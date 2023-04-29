package main

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
  "github.com/aztfmods/module-azurerm-vnet/shared"
)

func TestApplyNoError(t *testing.T) {
	t.Parallel()

	tests := []shared.TestCase{
		{Name: "simple", Path: "../examples/simple"},
		{Name: "ddos-protection", Path: "../examples/ddos-protection"},
		{Name: "diagnostic-settings", Path: "../examples/diagnostic-settings"},
		{Name: "nsg-rules", Path: "../examples/nsg-rules"},
		{Name: "service-endpoints", Path: "../examples/service-endpoints"},
		{Name: "delegations", Path: "../examples/delegations"},
	}

	for _, test := range tests {
		t.Run(test.Name, func(t *testing.T) {
			terraformOptions := shared.GetTerraformOptions(test.Path)

			terraform.WithDefaultRetryableErrors(t, &terraform.Options{})

			defer shared.Cleanup(t, terraformOptions)
			terraform.InitAndApply(t, terraformOptions)
		})
	}
}


