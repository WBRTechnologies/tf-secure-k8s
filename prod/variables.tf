variable "name" {
  type    = string
  default = "secure-k8s-cluster"
}

variable "region" {
  type    = string
  default = "blr1"
}

variable "tags" {
  type    = list(string)
  default = ["wat"]
}

variable "node_pool_name" {
  type    = string
  default = "default"
}

variable "node_size" {
  type    = string
  default = "s-1vcpu-2gb"
}

variable "node_count" {
  type    = number
  default = 1
}

variable "node_auto_scale" {
  type    = bool
  default = false
}

variable "node_min" {
  type    = number
  default = 1
}

variable "node_max" {
  type    = number
  default = 1
}

variable "node_labels" {
  type    = map(string)
  default = {}
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

variable "droplet_size" {
  type    = string
  default = "s-1vcpu-1gb"
}

variable "openvpn_name" {
  type    = string
  default = "openvpn-as-1"
}

variable "openvpn_image" {
  type    = string
  default = "201034671" // OpenVPN Access Server on Ubuntu 22.04 x64
}

variable "openvpn_admin_password" {
  type      = string
  sensitive = true
}
