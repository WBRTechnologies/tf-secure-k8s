# Makefile for Terraform + Kubernetes workflow
# ENV=dev (default) -> Kind; ENV=prod -> DigitalOcean

TF              ?= terraform
KUBECONFIG_PATH ?= $(HOME)/.kube/config
ENV             ?= dev

ifeq ($(ENV),dev)
	TF_DIR := dev
	CLUSTER_NAME := dev-kind
else
	TF_DIR := prod
	CLUSTER_NAME := secure-k8s-cluster
endif

.PHONY: init apply set-kubeconfig up destroy

init:
	@echo "🚀 Initializing Terraform ($(ENV))..."
	$(TF) -chdir=$(TF_DIR) init

apply:
	@echo "⚙️ Applying Terraform configuration ($(ENV))..."
	$(TF) -chdir=$(TF_DIR) apply -auto-approve

set-kubeconfig:
	@echo "🔐 Merging kubeconfig for $(CLUSTER_NAME) into $(KUBECONFIG_PATH)..."
	@mkdir -p $(HOME)/.kube
	@tmp_out=$$(mktemp); \
	$(TF) -chdir=$(TF_DIR) output -raw kubeconfig > "$$tmp_out"; \
	KUBECONFIG="$$tmp_out:$(KUBECONFIG_PATH)" kubectl config view --flatten > "$(KUBECONFIG_PATH).merged"; \
	mv -f "$(KUBECONFIG_PATH).merged" "$(KUBECONFIG_PATH)"; \
	rm -f "$$tmp_out"; \
	echo "✅ kubeconfig merged (context: $(CLUSTER_NAME))"

up: init apply set-kubeconfig

destroy:
	@echo "💥 Destroying infrastructure ($(ENV))..."
	$(TF) -chdir=$(TF_DIR) destroy -auto-approve
