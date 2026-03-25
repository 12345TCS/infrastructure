locals {
  base_tags = concat(var.tags, ["environment:${var.environment}", "managed-by:terraform"])
}

module "cluster" {
  source = "../../../modules/do-k8s-cluster"

  name               = var.cluster_name
  region             = var.region
  vpc_name           = var.vpc_name
  vpc_cidr           = var.vpc_cidr
  kubernetes_version = var.kubernetes_version
  node_pools         = var.node_pools
  tags               = local.base_tags
}
