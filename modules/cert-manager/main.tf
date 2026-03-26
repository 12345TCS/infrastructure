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
  wait             = true
  timeout          = 900
  cleanup_on_fail  = true

  set {
    name  = "crds.enabled"
    value = "true"
  }

  values = [
    yamlencode({
      nodeSelector = var.node_selector
      cainjector = {
        nodeSelector = var.node_selector
        resources = {
          requests = {
            cpu    = "50m"
            memory = "128Mi"
          }
          limits = {
            cpu    = "250m"
            memory = "256Mi"
          }
        }
      }
      webhook = {
        nodeSelector   = var.node_selector
        timeoutSeconds = 30
        resources = {
          requests = {
            cpu    = "50m"
            memory = "128Mi"
          }
          limits = {
            cpu    = "250m"
            memory = "256Mi"
          }
        }
        livenessProbe = {
          initialDelaySeconds = 60
          timeoutSeconds      = 5
          periodSeconds       = 10
          failureThreshold    = 6
        }
        readinessProbe = {
          initialDelaySeconds = 20
          timeoutSeconds      = 5
          periodSeconds       = 5
          failureThreshold    = 12
        }
      }
      resources = {
        requests = {
          cpu    = "50m"
          memory = "128Mi"
        }
        limits = {
          cpu    = "250m"
          memory = "256Mi"
        }
      }
    })
  ]
}
