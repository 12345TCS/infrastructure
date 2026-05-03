terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
  }
}

resource "helm_release" "this" {
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = var.namespace
  version          = var.chart_version
  create_namespace = var.create_namespace
  wait             = true
  timeout          = 1200
  cleanup_on_fail  = true

  values = [
    yamlencode({
      grafana = {
        adminPassword = var.grafana_admin_password
        service = {
          type = var.grafana_service_type
        }
        nodeSelector = var.node_selector
        persistence = {
          enabled          = var.grafana_persistence_enabled
          size             = var.grafana_persistence_size
          storageClassName = var.grafana_storage_class_name
        }
      }
      prometheus = {
        prometheusSpec = {
          nodeSelector = var.node_selector
          retention    = var.prometheus_retention
          storageSpec = var.prometheus_persistence_enabled ? {
            volumeClaimTemplate = {
              spec = {
                accessModes      = ["ReadWriteOnce"]
                storageClassName = var.prometheus_storage_class_name
                resources = {
                  requests = {
                    storage = var.prometheus_persistence_size
                  }
                }
              }
            }
          } : null
        }
      }
      alertmanager = {
        alertmanagerSpec = {
          nodeSelector = var.node_selector
          alertmanagerConfigMatcherStrategy = {
            type = "None"
          }
          alertmanagerConfigSelector = {
            matchLabels = {
              alertmanagerConfig = "platform-alerts"
            }
          }
          alertmanagerConfigNamespaceSelector = {
            matchNames = ["monitoring"]
          }
        }
      }
      kubeStateMetrics = {
        nodeSelector = var.node_selector
      }
      prometheusOperator = {
        nodeSelector = var.node_selector
      }
    })
  ]
}
