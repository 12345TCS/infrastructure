output "cluster_id" {
  value = module.cluster.cluster_id
}

output "cluster_name" {
  value = module.cluster.cluster_name
}

output "cluster_endpoint" {
  value = module.cluster.endpoint
}

output "cluster_token" {
  value     = module.cluster.token
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = module.cluster.cluster_ca_certificate
  sensitive = true
}

output "kubeconfig_raw" {
  value     = module.cluster.kubeconfig_raw
  sensitive = true
}

output "vpc_id" {
  value = module.cluster.vpc_id
}
