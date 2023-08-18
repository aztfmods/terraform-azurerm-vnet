.PHONY: complete test local

export WORKLOAD
export ENVIRONMENT
export USECASE

test_extended:
	cd tests && go test -v -timeout 60m -run TestVirtualNetwork ./vnet_extended_test.go

test:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/$(USECASE) ./vnet_test.go

test_local:
	cd tests && env WORKLOAD=demo ENVIRONMENT=dev go test -v -timeout 60m -run TestVirtualNetwork ./vnet_extended_test.go


#test_local:
#	cd tests && env WORKLOAD=demo ENVIRONMENT=dev go test -v -timeout 60m -run TestVirtualNetwork ./vnet_extended_test.go
