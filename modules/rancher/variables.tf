variable "namespace" {
  type    = string
  default = "cattle-system"
}

variable "chart_version" {
  type     = string
  default  = null
  nullable = true
}

variable "create_namespace" {
  type    = bool
  default = true
}

variable "hostname" {
  type = string
}

variable "bootstrap_password" {
  type      = string
  sensitive = true
}

variable "replicas" {
  type    = number
  default = 1
}

variable "ingress_class_name" {
  type    = string
  default = "kong"
}

variable "tls_source" {
  type    = string
  default = "rancher"
}

variable "node_selector" {
  type    = map(string)
  default = {}
}
