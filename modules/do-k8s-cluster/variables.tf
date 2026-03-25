variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "kubernetes_version" {
  type     = string
  default  = null
  nullable = true
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

variable "auto_upgrade" {
  type    = bool
  default = true
}

variable "surge_upgrade" {
  type    = bool
  default = true
}

variable "ha" {
  type    = bool
  default = false
}
