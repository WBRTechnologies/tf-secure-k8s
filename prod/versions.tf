terraform {
  required_version = ">= 1.5.7"

  required_providers {
    digitalocean = { source = "digitalocean/digitalocean", version = "~> 2.40" }
    kubernetes   = { source = "hashicorp/kubernetes", version = "~> 2.38" }
    helm         = { source = "hashicorp/helm", version = "~> 2.17" }
  }
}
