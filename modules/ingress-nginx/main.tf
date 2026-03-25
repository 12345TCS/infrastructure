terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
  }
}

resource "helm_release" "this" {
  name                       = "ingress-nginx"
  repository                 = "https://kubernetes.github.io/ingress-nginx"
  chart                      = "ingress-nginx"
  namespace                  = var.namespace
  version                    = var.chart_version
  create_namespace           = var.create_namespace
  wait                       = true
  timeout                    = 900
  cleanup_on_fail            = true
  disable_openapi_validation = true

  values = [
    yamlencode({
      controller = {
        ingressClassResource = {
          name = "nginx"
        }
        ingressClass = "nginx"
        service = {
          type = var.service_type
        }
      }
    })
  ]
}
