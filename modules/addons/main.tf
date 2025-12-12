##############################
# Ingress NGINX (Helm release)
##############################

resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true

  values = var.ingress_values
}

##############################
# Docker registry credentials secret
##############################

resource "kubernetes_secret" "docker_credentials" {
  metadata {
    name      = "docker-credentials"
    namespace = "default"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        (var.docker_registry_server) = {
          username = var.docker_registry_username
          password = var.docker_registry_password
          auth     = base64encode("${var.docker_registry_username}:${var.docker_registry_password}")
        }
      }
    })
  }
}
