# Used by `image`, `push` & `deploy` targets, override as required
IMAGE_REG ?= docker.io
IMAGE_REPO ?= yovazbz/blazorweb
IMAGE_TAG ?= latest

# Used by `test-api` target
TEST_HOST ?= localhost:5000

.PHONY: help lint image push run deploy undeploy test test-report test-api clean .EXPORT_ALL_VARIABLES
.DEFAULT_GOAL := help

image: ## 🔨 Build container image from Dockerfile 
	docker build . --file Dockerfile \
	--tag $(IMAGE_REG)/$(IMAGE_REPO):$(IMAGE_TAG)

push: ## 📤 Push container image to registry 
	docker push $(IMAGE_REG)/$(IMAGE_REPO):$(IMAGE_TAG)


