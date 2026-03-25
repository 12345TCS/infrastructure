output "cluster_endpoint" {
  value = data.terraform_remote_state.infra.outputs.cluster_endpoint
}

output "kubeconfig_raw" {
  value     = data.terraform_remote_state.infra.outputs.kubeconfig_raw
  sensitive = true
}
