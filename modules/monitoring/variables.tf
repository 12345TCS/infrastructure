variable "namespace" {
  type    = string
  default = "monitoring"
}

variable "chart_version" {
  type = string
}

variable "create_namespace" {
  type    = bool
  default = true
}

variable "grafana_admin_password" {
  type      = string
  sensitive = true
}

variable "grafana_service_type" {
  type    = string
  default = "ClusterIP"
}

variable "grafana_persistence_enabled" {
  type    = bool
  default = true
}

variable "grafana_persistence_size" {
  type    = string
  default = "5Gi"
}

variable "grafana_storage_class_name" {
  type     = string
  default  = null
  nullable = true
}

variable "prometheus_persistence_enabled" {
  type    = bool
  default = true
}

variable "prometheus_persistence_size" {
  type    = string
  default = "10Gi"
}

variable "prometheus_storage_class_name" {
  type     = string
  default  = null
  nullable = true
}

variable "prometheus_retention" {
  type    = string
  default = "7d"
}

variable "node_selector" {
  type    = map(string)
  default = { workload = "apps" }
}
