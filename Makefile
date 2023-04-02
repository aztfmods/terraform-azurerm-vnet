TF_WORKDIR := ../examples/complete

.PHONY: test simple

test:
	cd tests && TF_WD=$(TF_WORKDIR) go test -v

simple:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/simple

# simple:
# 	cd tests && go test -v -timeout 60m -run TestApplyNoError/simple

# simple:
# 	cd tests && go test -v -timeout 60m -run TestApplyNoError/simple

# simple:
# 	cd tests && go test -v -timeout 60m -run TestApplyNoError/simple