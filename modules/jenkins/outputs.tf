output "namespace" {
  value = var.namespace
}

output "service_name" {
  value = helm_release.this.name
}
