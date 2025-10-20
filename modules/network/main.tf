locals {
  app_secondary_ranges = [
    { range_name = "pods-range",     ip_cidr_range = var.app_pods_secondary_cidr },
    { range_name = "services-range", ip_cidr_range = var.app_services_secondary_cidr },
  ]
}

# Create or use existing VPC
resource "google_compute_network" "vpc" {
  count                   = var.create_network ? 1 : 0
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

data "google_compute_network" "existing" {
  count = var.create_network ? 0 : 1
  name  = var.network_name
}

# Canonical references
locals {
  network_id        = var.create_network ? google_compute_network.vpc[0].id : data.google_compute_network.existing[0].id
  network_name_real = var.create_network ? google_compute_network.vpc[0].name : data.google_compute_network.existing[0].name
  network_self_link = var.create_network ? google_compute_network.vpc[0].self_link : data.google_compute_network.existing[0].self_link
}

# Subnets (web/app/db for this env). Secondary ranges hanya untuk subnet app.
resource "google_compute_subnetwork" "subs" {
  for_each                 = { for s in var.subnets : s.name => s }
  name                     = each.value.name
  ip_cidr_range            = each.value.ip_cidr_range
  region                   = each.value.region
  network                  = local.network_id
  private_ip_google_access = true

  dynamic "secondary_ip_range" {
    for_each = can(regex("-app$", each.key)) ? local.app_secondary_ranges : []
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }
}

# Cloud Router + NAT for egress (optional)
resource "google_compute_router" "router" {
  count   = var.manage_router_nat ? 1 : 0
  name    = "${var.network_name}-router"
  region  = var.region
  network = local.network_id
}

resource "google_compute_router_nat" "nat" {
  count                              = var.manage_router_nat ? 1 : 0
  name                               = "${var.network_name}-nat"
  router                             = google_compute_router.router[0].name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

# Optional firewall to allow SSH from specific CIDR (tag: allow-ssh)
resource "google_compute_firewall" "allow_ssh" {
  count   = var.allow_ssh_cidr == null ? 0 : 1
  name    = "${var.network_name}-allow-ssh"
  network = local.network_name_real

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [var.allow_ssh_cidr]
  target_tags   = ["allow-ssh"]
}

# Reserved range for Service Networking (Cloud SQL Private IP) (optional)
resource "google_compute_global_address" "psc_sql_range" {
  count         = var.manage_psc ? 1 : 0
  name          = "${var.network_name}-psc-sql-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = local.network_id
}

# Name to use for PSC range even if not managed here
locals {
  psc_sql_range_name_effective = var.manage_psc ? google_compute_global_address.psc_sql_range[0].name : "${var.network_name}-psc-sql-range"
}