##############################
# KIND Kubernetes cluster (dev)
##############################

resource "kind_cluster" "this" {
  name           = var.name
  wait_for_ready = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"

      kubeadm_config_patches = [
        <<-EOT
        kind: InitConfiguration
        nodeRegistration:
          kubeletExtraArgs:
            node-labels: "ingress-ready=true"
        EOT
      ]

      extra_port_mappings {
        container_port = 80
        host_port      = 80
        protocol       = "TCP"
      }

      extra_port_mappings {
        container_port = 443
        host_port      = 443
        protocol       = "TCP"
      }
    }

    node {
      role = "worker"
    }
  }
}

##############################
# Kubernetes & Helm providers
##############################

provider "kubernetes" {
  config_path = kind_cluster.this.kubeconfig_path
}

provider "helm" {
  kubernetes {
    config_path = kind_cluster.this.kubeconfig_path
  }
}

##############################
# Shared addons (reuse module)
##############################

module "addons" {
  source = "../modules/addons"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  docker_registry_server   = var.docker_registry_server
  docker_registry_username = var.docker_registry_username
  docker_registry_password = var.docker_registry_password

  ingress_values = [
    <<-YAML
controller:
  service:
    type: NodePort
  hostPort:
    enabled: true
  nodeSelector:
    ingress-ready: "true"
  tolerations:
    - key: "node-role.kubernetes.io/control-plane"
      operator: "Equal"
      effect: "NoSchedule"
    - key: "node-role.kubernetes.io/master"
      operator: "Equal"
      effect: "NoSchedule"
YAML
  ]

  depends_on = [kind_cluster.this]
}
