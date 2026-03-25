variable "namespace" {
  type    = string
  default = "cert-manager"
}

variable "chart_version" {
  type = string
}

variable "create_namespace" {
  type    = bool
  default = true
}
