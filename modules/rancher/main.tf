terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
  }
}

resource "helm_release" "this" {
  name             = "rancher"
  repository       = "https://releases.rancher.com/server-charts/latest"
  chart            = "rancher"
  namespace        = var.namespace
  version          = var.chart_version
  create_namespace = var.create_namespace
  wait             = true
  timeout          = 900
  cleanup_on_fail  = true

  values = [
    yamlencode({
      hostname          = var.hostname
      bootstrapPassword = var.bootstrap_password
      replicas          = var.replicas
      nodeSelector      = var.node_selector
      ingress = {
        ingressClassName = var.ingress_class_name
        tls = {
          source = var.tls_source
        }
      }
    })
  ]
}
