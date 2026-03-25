variable "namespace" {
  type    = string
  default = "kong"
}

variable "chart_version" {
  type = string
}

variable "create_namespace" {
  type    = bool
  default = true
}

variable "replica_count" {
  type    = number
  default = 1
}

variable "proxy_type" {
  type    = string
  default = "LoadBalancer"
}

variable "admin_enabled" {
  type    = bool
  default = false
}

variable "admin_service_type" {
  type    = string
  default = "ClusterIP"
}

variable "admin_http_enabled" {
  type    = bool
  default = false
}

variable "admin_tls_enabled" {
  type    = bool
  default = true
}

variable "manager_enabled" {
  type    = bool
  default = false
}

variable "manager_service_type" {
  type    = string
  default = "ClusterIP"
}

variable "manager_http_enabled" {
  type    = bool
  default = true
}

variable "manager_tls_enabled" {
  type    = bool
  default = false
}

variable "db_less" {
  type    = bool
  default = true
}

variable "database" {
  type = object({
    host     = string
    port     = number
    username = string
    password = string
    name     = string
    ssl      = string
    verify   = string
  })
  default  = null
  nullable = true
}

variable "resources" {
  type = object({
    requests_cpu    = string
    requests_memory = string
    limits_cpu      = string
    limits_memory   = string
  })
}

variable "timeout_seconds" {
  type    = number
  default = 900
}

variable "admin_gui_url" {
  type     = string
  default  = null
  nullable = true
}

variable "admin_gui_api_url" {
  type     = string
  default  = null
  nullable = true
}

variable "admin_gui_session_conf" {
  type     = string
  default  = null
  nullable = true
}

variable "node_selector" {
  type    = map(string)
  default = {}
}
