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

  depends_on = [module.cert_manager, module.kong_postgres]
}

module "rancher" {
  source = "../../../modules/rancher"

  chart_version      = var.rancher_chart_version
  hostname           = var.rancher_hostname
  bootstrap_password = var.rancher_bootstrap_password
  replicas           = var.rancher_replicas
  ingress_class_name = var.rancher_ingress_class_name
  tls_source         = var.rancher_tls_source

  depends_on = [module.ingress_nginx]
}
