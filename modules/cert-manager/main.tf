terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
  }
}

resource "helm_release" "this" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = var.namespace
  version          = var.chart_version
  create_namespace = var.create_namespace

  set {
    name  = "crds.enabled"
    value = "true"
  }
}
