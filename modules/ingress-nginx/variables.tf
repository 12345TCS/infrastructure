variable "namespace" {
  type    = string
  default = "ingress-nginx"
}

variable "chart_version" {
  type = string
}

variable "create_namespace" {
  type    = bool
  default = true
}

variable "service_type" {
  type    = string
  default = "LoadBalancer"
}
