terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
  }
}

data "digitalocean_kubernetes_versions" "this" {}

locals {
  selected_kubernetes_version = coalesce(
    var.kubernetes_version,
    data.digitalocean_kubernetes_versions.this.latest_version
  )

  primary_node_pool    = var.node_pools[0]
  additional_node_pools = slice(var.node_pools, 1, length(var.node_pools))
}

resource "digitalocean_vpc" "this" {
  name     = var.vpc_name
  region   = var.region
  ip_range = var.vpc_cidr
}

resource "digitalocean_kubernetes_cluster" "this" {
  name          = var.name
  region        = var.region
  version       = local.selected_kubernetes_version
  vpc_uuid      = digitalocean_vpc.this.id
  auto_upgrade  = var.auto_upgrade
  surge_upgrade = var.surge_upgrade
  ha            = var.ha
  tags          = var.tags

  node_pool {
    name       = local.primary_node_pool.name
    size       = local.primary_node_pool.size
    node_count = local.primary_node_pool.node_count
    tags       = var.tags
    labels     = try(local.primary_node_pool.labels, {})
  }
}

resource "digitalocean_kubernetes_node_pool" "this" {
  for_each = {
    for pool in local.additional_node_pools : pool.name => pool
  }

  cluster_id = digitalocean_kubernetes_cluster.this.id
  name       = each.value.name
  size       = each.value.size
  node_count = each.value.node_count
  tags       = var.tags
  labels     = try(each.value.labels, {})
}
