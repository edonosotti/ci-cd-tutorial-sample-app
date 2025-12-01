#   make build               # build image tagged with git short commit (or 'latest')
#   make login               # docker login using DOCKERHUB_USER / DOCKERHUB_PASS env vars
#   make push                # login, build and push image:<tag>
#   make push-latest         # tag built image as :latest and push
#   make pull-latest         # pull image:latest from Docker Hub

DOCKERHUB_USER ?= viyd
IMAGE ?= $(DOCKERHUB_USER)/cicd-app
TAG ?= $(shell git rev-parse --short HEAD 2>/dev/null || echo latest)
FULL_IMAGE := $(IMAGE):$(TAG)

.PHONY: all build login push push-latest pull-latest help

all: build

help:
	@echo "Targets:"
	@echo "  make build         Build docker image ($(FULL_IMAGE))"
	@echo "  make login         Docker login (requires DOCKERHUB_USER and DOCKERHUB_PASS env vars)"
	@echo "  make push          Login, build and push $(FULL_IMAGE)"
	@echo "  make push-latest   Tag built image as $(IMAGE):latest and push"
	@echo "  make pull-latest   Pull $(IMAGE):latest from Docker Hub"

build:
	docker build -t $(FULL_IMAGE) .

# login:
# ifndef DOCKERHUB_USER
# 	$(error DOCKERHUB_USER is not set)
# endif
# ifndef DOCKERHUB_PASS
# 	$(error DOCKERHUB_PASS is not set)
# endif
# 	@echo "Logging in to Docker Hub as $(DOCKERHUB_USER)"
# 	@printf '%s\n' "$(DOCKERHUB_PASS)" | docker login -u "$(DOCKERHUB_USER)" --password-stdin

login:
	@docker login

push: login build
	@echo "Pushing $(FULL_IMAGE)"
	docker push $(FULL_IMAGE)

push-latest: login build
	@echo "Tagging $(FULL_IMAGE) as $(IMAGE):latest and pushing"
	docker tag $(FULL_IMAGE) $(IMAGE):latest
	docker push $(FULL_IMAGE)
	docker push $(IMAGE):latest

pull:
	@echo "Pulling $(FULL_IMAGE)"
	docker pull $(FULL_IMAGE)

pull-latest:
	@echo "Pulling $(IMAGE):latest"
	docker pull $(IMAGE):latest

delete-test-images:
	-docker rmi -f $(IMAGE):test || true

deploy-stage:
	ansible-playbook -i ansible/inventory.ini ansible/deploy.yml

deploy-prod:
	kubectl rollout restart deployment/cicd-app
	kubectl rollout status deployment/cicd-app

deploy-specific-prod:
	kubectl set image deployment/cicd-app cicd-app=$(FULL_IMAGE)
	kubectl rollout status deployment/cicd-app
