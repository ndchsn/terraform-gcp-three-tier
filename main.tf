locals {
  subnet_web_name = "subnet-${var.env}-web"
  subnet_app_name = "subnet-${var.env}-app"
  subnet_db_name  = "subnet-${var.env}-db"
}

module "network" {
  source       = "./modules/network"
  project_id   = var.project_id
  region       = var.region
  network_name = var.network_name

  # Manage or consume the VPC
  create_network    = var.network_create_network
  manage_router_nat = var.network_manage_router_nat
  manage_psc        = var.network_manage_psc

  subnets = [
    { name = local.subnet_web_name, ip_cidr_range = var.tier_cidrs.web, region = var.region },
    { name = local.subnet_app_name, ip_cidr_range = var.tier_cidrs.app, region = var.region },
    { name = local.subnet_db_name,  ip_cidr_range = var.tier_cidrs.db,  region = var.region },
  ]

  # Secondary ranges for GKE on the app subnet (per env)
  app_pods_secondary_cidr     = var.app_pods_secondary_cidr
  app_services_secondary_cidr = var.app_services_secondary_cidr

  # Optional: allow SSH from your IP (tag based)
  allow_ssh_cidr = var.tags_allow_ssh_cidr
}

module "gke" {
  source                 = "./modules/gke"
  project_id             = var.project_id
  region                 = var.region
  network                = module.network.network_self_link
  subnetwork             = module.network.subnet_self_links[local.subnet_app_name]
  ip_range_pods_name     = module.network.pods_range_name
  ip_range_services_name = module.network.svcs_range_name

  cluster_name        = var.gke.cluster_name
  release_channel     = var.gke.release_channel
  kubernetes_version  = try(var.gke.kubernetes_version, null)
  nodepool = {
    min_nodes    = var.gke.min_nodes
    max_nodes    = var.gke.max_nodes
    machine_type = var.gke.machine_type
  }
}

module "sql" {
  source               = "./modules/sql"
  project_id           = var.project_id
  region               = var.region
  network_self_link    = module.network.network_self_link
  allocated_range_name = module.network.psc_sql_range_name
  manage_connection    = var.network_manage_psc

  instance_name     = var.sql.instance_name
  database_version  = var.sql.database_version
  tier              = var.sql.tier
  disk_size_gb      = var.sql.disk_size_gb
  availability_type = var.sql.availability_type

  database_name = var.sql.database_name
  user_name     = var.sql.user_name
}