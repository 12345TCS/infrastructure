locals {
  kong_database = var.kong_db_less ? null : {
    host     = module.kong_postgres[0].host
    port     = module.kong_postgres[0].port
    username = module.kong_postgres[0].username
    password = module.kong_postgres[0].password
    name     = module.kong_postgres[0].database_name
    ssl      = "off"
    verify   = "off"
  }
}

module "cert_manager" {
  source = "../../../modules/cert-manager"

  chart_version = var.cert_manager_chart_version
  node_selector = var.cert_manager_node_selector
}

module "ingress_nginx" {
  source = "../../../modules/ingress-nginx"

  chart_version = var.ingress_nginx_chart_version

  depends_on = [module.cert_manager]
}

module "kong_postgres" {
  count  = var.kong_db_less ? 0 : 1
  source = "../../../modules/kong-postgres"

  image              = var.kong_postgres_image
  database_name      = var.kong_postgres_database_name
  username           = var.kong_postgres_username
  password           = var.kong_postgres_password
  storage_size       = var.kong_postgres_storage_size
  storage_class_name = var.kong_postgres_storage_class_name
  node_selector      = var.kong_postgres_node_selector
}

module "monitoring" {
  source = "../../../modules/monitoring"

  chart_version                 = var.monitoring_chart_version
  grafana_admin_password        = var.grafana_admin_password
  grafana_service_type          = var.grafana_service_type
  grafana_persistence_size      = var.grafana_persistence_size
  grafana_storage_class_name    = var.grafana_storage_class_name
  prometheus_persistence_size   = var.prometheus_persistence_size
  prometheus_storage_class_name = var.prometheus_storage_class_name
  prometheus_retention          = var.prometheus_retention
  node_selector                 = var.monitoring_node_selector

  depends_on = [module.cert_manager]
}

module "kong" {
  source = "../../../modules/kong"

  chart_version          = var.kong_chart_version
  replica_count          = var.kong_replica_count
  admin_enabled          = var.kong_admin_enabled
  admin_service_type     = var.kong_admin_service_type
  admin_http_enabled     = var.kong_admin_http_enabled
  admin_tls_enabled      = var.kong_admin_tls_enabled
  manager_enabled        = var.kong_manager_enabled
  manager_service_type   = var.kong_manager_service_type
  manager_http_enabled   = var.kong_manager_http_enabled
  manager_tls_enabled    = var.kong_manager_tls_enabled
  db_less                = var.kong_db_less
  database               = local.kong_database
  resources              = var.kong_resources
  timeout_seconds        = var.kong_timeout_seconds
  admin_gui_url          = var.kong_admin_gui_url
  admin_gui_api_url      = var.kong_admin_gui_api_url
  admin_gui_session_conf = var.kong_admin_gui_session_conf
  node_selector          = var.kong_node_selector

  depends_on = [module.cert_manager, module.kong_postgres, module.monitoring]
}

module "rancher" {
  source = "../../../modules/rancher"

  chart_version      = var.rancher_chart_version
  hostname           = var.rancher_hostname
  bootstrap_password = var.rancher_bootstrap_password
  replicas           = var.rancher_replicas
  ingress_class_name = var.rancher_ingress_class_name
  tls_source         = var.rancher_tls_source
  node_selector      = var.rancher_node_selector

  depends_on = [module.ingress_nginx, module.cert_manager]
}

module "jenkins" {
  source = "../../../modules/jenkins"

  chart_version                     = var.jenkins_chart_version
  admin_username                    = var.jenkins_admin_username
  admin_password                    = var.jenkins_admin_password
  service_type                      = var.jenkins_service_type
  persistence_size                  = var.jenkins_persistence_size
  storage_class_name                = var.jenkins_storage_class_name
  node_selector                     = var.jenkins_node_selector
  prometheus_enabled                = var.jenkins_prometheus_enabled
  prometheus_scrape_endpoint        = var.jenkins_prometheus_scrape_endpoint
  prometheus_scrape_interval        = var.jenkins_prometheus_scrape_interval
  prometheus_service_monitor_labels = var.jenkins_prometheus_service_monitor_labels
  resources                         = var.jenkins_resources
  timeout_seconds                   = var.jenkins_timeout_seconds

  depends_on = [module.monitoring]
}
