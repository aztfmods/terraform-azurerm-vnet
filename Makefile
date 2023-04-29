.PHONY: complete simple delegations nsg-rules service-endpoints ddos-protection diagnostic-settings

complete:
	cd tests && go test -v -timeout 60m -run TestVirtualNetwork ./vnet_extended_test.go

simple:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/simple ./vnet_test.go

delegations:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/delegations ./vnet_test.go

nsg-rules:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/nsg-rules ./vnet_test.go

service-endpoints:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/service-endpoints ./vnet_test.go

ddos-protection:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/ddos-protection ./vnet_test.go

diagnostic-settings:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/diagnostic-settings ./vnet_test.go

