##############################
# DigitalOcean Kubernetes cluster (prod)
##############################

data "digitalocean_kubernetes_versions" "stable" {}

resource "digitalocean_kubernetes_cluster" "this" {
  name    = var.name
  region  = var.region
  version = data.digitalocean_kubernetes_versions.stable.latest_version

  node_pool {
    name       = var.node_pool_name
    size       = var.node_size
    node_count = var.node_count
    auto_scale = var.node_auto_scale
    min_nodes  = var.node_min
    max_nodes  = var.node_max
    labels     = var.node_labels
  }

  tags = var.tags
}

##############################
# Kubernetes & Helm providers
##############################

provider "kubernetes" {
  host                   = digitalocean_kubernetes_cluster.this.endpoint
  token                  = digitalocean_kubernetes_cluster.this.kube_config[0].token
  cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = digitalocean_kubernetes_cluster.this.endpoint
    token                  = digitalocean_kubernetes_cluster.this.kube_config[0].token
    cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate)
  }
}

##############################
# Shared addons (ingress + registry secret)
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
    annotations:
      "service.beta.kubernetes.io/do-loadbalancer-network": "INTERNAL"
YAML
  ]

  depends_on = [digitalocean_kubernetes_cluster.this]
}

##############################
# OpenVPN Server Droplet
##############################

resource "digitalocean_droplet" "openvpn" {
  name       = var.openvpn_name
  region     = var.region
  size       = var.droplet_size
  tags       = var.tags
  image      = var.openvpn_image
  ipv6       = false
  monitoring = false

  user_data = <<-EOF
    #cloud-config
    runcmd:
      # Run Access Server init with defaults
      - /usr/local/openvpn_as/bin/ovpn-init --batch --local_auth

      # Set admin user password and permissions
      - cd /usr/local/openvpn_as/scripts
      - ./sacli --user "openvpn" --key "prop_superuser" --value "true" UserPropPut
      - ./sacli --user "openvpn" --key "user_auth_type" --value "local" UserPropPut
      - ./sacli --user "openvpn" --new_pass "${var.openvpn_admin_password}" SetLocalPassword
  EOF
}
