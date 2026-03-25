variable "environment" {
  type    = string
  default = "prod"
}

variable "do_token" {
  type      = string
  sensitive = true
}

variable "region" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "node_pools" {
  type = list(object({
    name       = string
    size       = string
    node_count = number
    labels     = optional(map(string), {})
  }))
}

variable "tags" {
  type    = list(string)
  default = []
}
