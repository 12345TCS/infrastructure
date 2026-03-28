terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
  }
}

resource "helm_release" "this" {
  name             = "jenkins"
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  namespace        = var.namespace
  version          = var.chart_version
  create_namespace = var.create_namespace
  wait             = true
  timeout          = var.timeout_seconds
  cleanup_on_fail  = true

  values = [
    yamlencode({
      controller = {
        admin = {
          username = var.admin_username
          password = var.admin_password
        }
        installLatestPlugins          = true
        installLatestSpecifiedPlugins = true
        serviceType                   = var.service_type
        nodeSelector                  = var.node_selector
        ingress = {
          enabled = false
        }
        persistence = {
          enabled          = var.persistence_enabled
          size             = var.persistence_size
          storageClassName = var.storage_class_name
        }
        resources = {
          requests = {
            cpu    = var.resources.requests_cpu
            memory = var.resources.requests_memory
          }
          limits = {
            cpu    = var.resources.limits_cpu
            memory = var.resources.limits_memory
          }
        }
      }
    })
  ]
}
