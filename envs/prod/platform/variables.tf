variable "cert_manager_chart_version" {
  type = string
}

variable "ingress_nginx_chart_version" {
  type = string
}

variable "kong_chart_version" {
  type = string
}

variable "rancher_chart_version" {
  type     = string
  default  = null
  nullable = true
}

variable "monitoring_chart_version" {
  type = string
}

variable "kong_replica_count" {
  type    = number
  default = 1
}

variable "kong_admin_enabled" {
  type    = bool
  default = false
}

variable "kong_admin_service_type" {
  type    = string
  default = "ClusterIP"
}

variable "kong_admin_http_enabled" {
  type    = bool
  default = true
}

variable "kong_admin_tls_enabled" {
  type    = bool
  default = false
}

variable "kong_manager_enabled" {
  type    = bool
  default = true
}

variable "kong_manager_service_type" {
  type    = string
  default = "ClusterIP"
}

variable "kong_manager_http_enabled" {
  type    = bool
  default = true
}

variable "kong_manager_tls_enabled" {
  type    = bool
  default = false
}

variable "kong_db_less" {
  type    = bool
  default = false
}

variable "kong_timeout_seconds" {
  type    = number
  default = 900
}

variable "kong_resources" {
  type = object({
    requests_cpu    = string
    requests_memory = string
    limits_cpu      = string
    limits_memory   = string
  })
}

variable "kong_postgres_image" {
  type    = string
  default = "postgres:15-alpine"
}

variable "kong_postgres_database_name" {
  type    = string
  default = "kong"
}

variable "kong_postgres_username" {
  type    = string
  default = "kong"
}

variable "kong_postgres_password" {
  type      = string
  sensitive = true
}

variable "kong_postgres_storage_size" {
  type    = string
  default = "8Gi"
}

variable "kong_postgres_storage_class_name" {
  type     = string
  default  = null
  nullable = true
}

variable "kong_node_selector" {
  type    = map(string)
  default = { workload = "kong" }
}

variable "kong_postgres_node_selector" {
  type    = map(string)
  default = { workload = "kong" }
}

variable "rancher_hostname" {
  type = string
}

variable "rancher_bootstrap_password" {
  type      = string
  sensitive = true
}

variable "rancher_replicas" {
  type    = number
  default = 1
}

variable "rancher_tls_source" {
  type    = string
  default = "rancher"
}

variable "rancher_ingress_class_name" {
  type    = string
  default = "nginx"
}

variable "rancher_node_selector" {
  type    = map(string)
  default = { workload = "rancher" }
}

variable "kong_admin_gui_url" {
  type    = string
  default = "http://127.0.0.1:8002"
}

variable "kong_admin_gui_api_url" {
  type    = string
  default = "http://127.0.0.1:8001"
}

variable "kong_admin_gui_session_conf" {
  type    = string
  default = "{\"secret\":\"replace-me-dev-secret\",\"storage\":\"kong\",\"cookie_secure\":false}"
}

variable "grafana_admin_password" {
  type      = string
  sensitive = true
}

variable "grafana_service_type" {
  type    = string
  default = "ClusterIP"
}

variable "grafana_persistence_size" {
  type    = string
  default = "20Gi"
}

variable "grafana_storage_class_name" {
  type     = string
  default  = null
  nullable = true
}

variable "prometheus_persistence_size" {
  type    = string
  default = "50Gi"
}

variable "prometheus_storage_class_name" {
  type     = string
  default  = null
  nullable = true
}

variable "prometheus_retention" {
  type    = string
  default = "15d"
}

variable "monitoring_node_selector" {
  type    = map(string)
  default = { workload = "monitoring" }
}



variable "cert_manager_node_selector" {
  type    = map(string)
  default = { workload = "rancher" }
}

