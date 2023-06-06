.PHONY: complete test local

export WORKLOAD
export ENVIRONMENT
export TEST

complete:
	cd tests && go test -v -timeout 60m -run TestVirtualNetwork ./vnet_extended_test.go

test:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/$(TEST) ./vnet_test.go

local:
	cd tests && env WORKLOAD=demo ENVIRONMENT=dev go test -v -timeout 60m -run TestVirtualNetwork ./vnet_extended_test.go
