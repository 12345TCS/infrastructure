output "cluster_id" {
  value = digitalocean_kubernetes_cluster.this.id
}

output "cluster_name" {
  value = digitalocean_kubernetes_cluster.this.name
}

output "endpoint" {
  value = digitalocean_kubernetes_cluster.this.endpoint
}

output "token" {
  value     = digitalocean_kubernetes_cluster.this.kube_config[0].token
  sensitive = true
}

output "cluster_ca_certificate" {
  value = base64decode(digitalocean_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate)
}

output "kubeconfig_raw" {
  value     = digitalocean_kubernetes_cluster.this.kube_config[0].raw_config
  sensitive = true
}

output "vpc_id" {
  value = digitalocean_vpc.this.id
}
