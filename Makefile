TF_WORKDIR := ../examples/complete

.PHONY: test

test:
	cd tests && TF_WD=$(TF_WORKDIR) go test -v
