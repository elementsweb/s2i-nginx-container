IMAGE_NAME = s2i-nginx-container
PORT = 8080
USER_ID := $(shell id -u $(whoami))

.PHONY: build
# Build the docker container
build:
	docker build -t $(IMAGE_NAME) .

.PHONY: test
# Test the base container works correctly
test:
	docker build -t $(IMAGE_NAME)-candidate .
	IMAGE_NAME=$(IMAGE_NAME)-candidate test/run

.PHONY: s2i_build
# Run s2i build using data from test/test-app
s2i_build:
	s2i build test/test-app $(IMAGE_NAME) $(IMAGE_NAME)-app

.PHONY: run
# Run the built container
run:
	docker run -p $(PORT):$(PORT) $(IMAGE_NAME)-app

.PHONY: run_non_root
# Run built container as non-root user for debugging
run_non_root:
	docker run -u $(USER_ID) -p $(PORT):$(PORT) $(IMAGE_NAME)-app

.PHONY: run_exec
# Run command in the built container
run_exec:
	docker run -it $(IMAGE_NAME) /bin/bash

.PHONY: all
all: build s2i_build run
