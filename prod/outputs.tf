output "cluster_id" {
  value       = digitalocean_kubernetes_cluster.this.id
  description = "DigitalOcean Kubernetes cluster ID"
}

output "cluster_name" {
  value       = digitalocean_kubernetes_cluster.this.name
  description = "Human-friendly cluster name"
}

output "endpoint" {
  value       = digitalocean_kubernetes_cluster.this.endpoint
  description = "Kubernetes API server endpoint URL"
}

output "kubeconfig" {
  value       = digitalocean_kubernetes_cluster.this.kube_config[0].raw_config
  sensitive   = true
  description = "Raw kubeconfig for accessing the cluster (sensitive)"
}

output "openvpn_public_ipv4" {
  value       = "https://${digitalocean_droplet.openvpn.ipv4_address}:943"
  description = "Public HTTPS URL for the OpenVPN Access Server"
}
