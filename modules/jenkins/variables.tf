variable "namespace" {
  type    = string
  default = "jenkins"
}

variable "chart_version" {
  type = string
}

variable "create_namespace" {
  type    = bool
  default = true
}

variable "timeout_seconds" {
  type    = number
  default = 1200
}

variable "admin_username" {
  type    = string
  default = "admin"
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "service_type" {
  type    = string
  default = "ClusterIP"
}

variable "persistence_enabled" {
  type    = bool
  default = true
}

variable "persistence_size" {
  type    = string
  default = "10Gi"
}

variable "storage_class_name" {
  type     = string
  default  = null
  nullable = true
}

variable "node_selector" {
  type    = map(string)
  default = { workload = "jenkins" }
}

variable "prometheus_enabled" {
  type    = bool
  default = true
}

variable "prometheus_scrape_endpoint" {
  type    = string
  default = "/prometheus/"
}

variable "prometheus_scrape_interval" {
  type    = string
  default = "60s"
}

variable "prometheus_service_monitor_labels" {
  type    = map(string)
  default = {}
}

variable "resources" {
  type = object({
    requests_cpu    = string
    requests_memory = string
    limits_cpu      = string
    limits_memory   = string
  })
}
