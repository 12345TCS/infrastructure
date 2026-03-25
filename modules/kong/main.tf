terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
  }
}

locals {
  kong_env = merge(
    {
      database = var.db_less ? "off" : "postgres"
    },
    var.manager_enabled && var.admin_gui_url != null ? {
      admin_gui_url = var.admin_gui_url
    } : {},
    var.manager_enabled && var.admin_gui_api_url != null ? {
      admin_gui_api_url = var.admin_gui_api_url
    } : {},
    var.manager_enabled && var.admin_gui_session_conf != null ? {
      admin_gui_session_conf = var.admin_gui_session_conf
    } : {},
    var.db_less ? {} : {
      pg_host       = var.database.host
      pg_port       = tostring(var.database.port)
      pg_user       = var.database.username
      pg_password   = var.database.password
      pg_database   = var.database.name
      pg_ssl        = var.database.ssl
      pg_ssl_verify = var.database.verify
    }
  )
}

resource "helm_release" "this" {
  name             = "kong"
  repository       = "https://charts.konghq.com"
  chart            = "kong"
  namespace        = var.namespace
  version          = var.chart_version
  create_namespace = var.create_namespace
  wait             = true
  timeout          = var.timeout_seconds
  cleanup_on_fail  = true

  values = [
    yamlencode({
      deployment = {
        kong = {
          enabled      = true
          nodeSelector = var.node_selector
        }
      }
      replicaCount = var.replica_count
      env          = local.kong_env
      ingressController = {
        enabled = true
      }
      postgresql = {
        enabled = false
      }
      proxy = {
        type = var.proxy_type
      }
      admin = {
        enabled = var.admin_enabled
        type    = var.admin_service_type
        http = {
          enabled = var.admin_http_enabled
        }
        tls = {
          enabled = var.admin_tls_enabled
        }
      }
      manager = {
        enabled = var.manager_enabled
        type    = var.manager_service_type
        http = {
          enabled = var.manager_http_enabled
        }
        tls = {
          enabled = var.manager_tls_enabled
        }
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
    })
  ]
}
