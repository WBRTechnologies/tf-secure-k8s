output "cluster_name" {
  value       = kind_cluster.this.name
  description = "Human-friendly cluster name for the dev Kind cluster"
}

output "kubeconfig" {
  value       = kind_cluster.this.kubeconfig
  sensitive   = true
  description = "Raw kubeconfig for accessing the dev cluster (sensitive)"
}
