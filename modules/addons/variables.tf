variable "docker_registry_server" {
  type = string
}

variable "docker_registry_username" {
  type      = string
  sensitive = true
}

variable "docker_registry_password" {
  type      = string
  sensitive = true
}

variable "ingress_values" {
  description = "YAML values list for the ingress-nginx Helm chart"
  type        = list(string)
}
