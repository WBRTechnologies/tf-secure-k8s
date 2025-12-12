variable "name" {
  type    = string
  default = "dev-kind"
}

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
