.PHONY: complete simple delegations nsg-rules service-endpoints ddos-protection diagnostic-settings

complete:
	cd tests && go test -v -timeout 60m -run TestVirtualNetwork

simple:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/simple

delegations:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/delegations

nsg-rules:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/nsg-rules

service-endpoints:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/service-endpoints

ddos-protection:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/ddos-protection

diagnostic-settings:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/diagnostic-settings