terraform {
  required_version = ">= 1.5.7"

  required_providers {
    kind       = { source = "tehcyx/kind", version = "~> 0.6" }
    kubernetes = { source = "hashicorp/kubernetes", version = "~> 2.38" }
    helm       = { source = "hashicorp/helm", version = "~> 2.17" }
  }
}
