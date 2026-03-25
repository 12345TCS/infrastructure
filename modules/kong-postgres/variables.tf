variable "namespace" {
  type    = string
  default = "kong"
}

variable "name" {
  type    = string
  default = "kong-postgres"
}

variable "image" {
  type    = string
  default = "postgres:15-alpine"
}

variable "database_name" {
  type    = string
  default = "kong"
}

variable "username" {
  type    = string
  default = "kong"
}

variable "password" {
  type      = string
  sensitive = true
}

variable "storage_size" {
  type    = string
  default = "8Gi"
}

variable "storage_class_name" {
  type     = string
  default  = null
  nullable = true
}

variable "cpu_request" {
  type    = string
  default = "100m"
}

variable "memory_request" {
  type    = string
  default = "256Mi"
}

variable "cpu_limit" {
  type    = string
  default = "500m"
}

variable "memory_limit" {
  type    = string
  default = "512Mi"
}

variable "node_selector" {
  type    = map(string)
  default = {}
}
