ORG ?=
IMAGE_USER := pulp
IMAGE_UID := $(shell id -u $(IMAGE_USER))
IMAGE_GID := $(shell id -g $(IMAGE_USER))

images: build-pulp-core \
        build-pulp-api \
        build-pulp-content \
        build-pulp-resource-manager \
        build-pulp-worker

build-%:
	$(eval IMAGE := $(patsubst build-%,%,$@))
	sed -i "s,FROM pulp-core,FROM $(ORG)pulp-core,g" $(IMAGE)/Dockerfile
	cd $(IMAGE) && docker build --tag $(ORG)$(IMAGE) \
	    --build-arg IMAGE_USER=$(IMAGE_USER) \
	    --build-arg IMAGE_UID=$(IMAGE_UID) \
	    --build-arg IMAGE_GID=$(IMAGE_GID) \
	    .
