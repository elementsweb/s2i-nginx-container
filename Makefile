IMAGE_NAME = s2i-nginx-container

.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .

.PHONY: test
test:
	docker build -t $(IMAGE_NAME)-candidate .
	IMAGE_NAME=$(IMAGE_NAME)-candidate test/run

.PHONY: s2i_build
s2i_build:
	s2i build test/test-app $(IMAGE_NAME) $(IMAGE_NAME)-app

.PHONY: run
run:
	docker run -p 8080:8080 $(IMAGE_NAME)-app

.PHONY: run_exec
run_exec:
	docker run -it $(IMAGE_NAME) /bin/bash

.PHONY: all
all: build s2i_build run
