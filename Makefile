.PHONY: complete simple local

export WORKLOAD
export ENVIRONMENT

complete:
	cd tests && go test -v -timeout 60m -run TestVirtualNetwork ./vnet_extended_test.go

simple:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/simple ./vnet_test.go

local:
	cd tests && env WORKLOAD=demo ENVIRONMENT=dev go test -v -timeout 60m -run TestVirtualNetwork ./vnet_extended_test.go

