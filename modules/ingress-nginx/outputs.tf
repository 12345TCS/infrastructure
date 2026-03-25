output "namespace" {
  value = helm_release.this.namespace
}

output "release_name" {
  value = helm_release.this.name
}
