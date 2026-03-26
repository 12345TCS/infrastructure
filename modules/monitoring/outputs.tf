output "namespace" {
  value = var.namespace
}

output "grafana_service_name" {
  value = "kube-prometheus-stack-grafana"
}

output "prometheus_service_name" {
  value = "kube-prometheus-stack-prometheus"
}
