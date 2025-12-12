# Secure Kubernetes: Prod (DigitalOcean) + Dev (Kind)

## Description

This repository contains Terraform configurations to provision a private, production Kubernetes cluster on DigitalOcean and a matching local Kind cluster for development. It is designed for applications that must not be internet-facing (for example, financial services, banking backends, or admin systems) and are intended to be accessed only via secure VPN or private networking.

Two deployment paths (via the provided `Makefile`):
- **Prod (DigitalOcean):** Private cluster with internal ingress, private registry credentials, and VPN access.
- **Dev (Kind):** Local cluster that mirrors the prod setup for testing and development.

## Why this exists

 - Keep production private: API and ingress are scoped to internal networks; access is via VPN or private network.
 - Make development repeatable: run a local equivalent cluster for safe testing without cloud costs.

## Prerequisites

Install these tools locally:
- `make` — task runner
- `kubectl` — Kubernetes CLI
- `helm` — Kubernetes package manager
- `docker` — container runtime (required for Kind)
- `terraform` v1.x — infrastructure as code

Set environment variables before running the Make targets (adjust values):

```bash
export TF_VAR_docker_registry_server="registry.example.com"
export TF_VAR_docker_registry_username="your-username"
export TF_VAR_docker_registry_password="your-token"
export TF_VAR_openvpn_admin_password="password-for-openvpn-admin-user"   # prod only
export DIGITALOCEAN_TOKEN="do_api_token"                                 # prod only
```

## Installation

- **Local (default):**
  ```bash
  make up
  ```

- **Prod:**
  ```bash
  make up ENV=prod
  ```

`make up` initializes Terraform, applies the selected environment, merges the generated kubeconfig into `~/.kube/config` (preserving other contexts), and sets the new cluster as the current context.

## Usage

- **Prod:**
  1. Get the VPN IP: `terraform output openvpn_public_ipv4`
  2. Download the `.ovpn` profile and connect with a VPN client
  3. Use `kubectl` and `helm` with the merged kubeconfig

 - **Dev:** kubeconfig is merged automatically; use `kubectl` and `helm` to manage the cluster.

### Pulling images from your private registry

In your Kubernetes manifests:

```yaml
imagePullSecrets:
  - name: docker-credentials
```

## Uninstall

- Local: `make destroy`
- Prod: `make destroy ENV=prod`
