output "host" {
  value = kubernetes_service.postgres.metadata[0].name
}

output "port" {
  value = 5432
}

output "username" {
  value = var.username
}

output "password" {
  value     = var.password
  sensitive = true
}

output "database_name" {
  value = var.database_name
}
