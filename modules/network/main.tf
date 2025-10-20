locals {
  app_secondary_ranges = [
    { range_name = "pods-range",     ip_cidr_range = var.app_pods_secondary_cidr },
    { range_name = "services-range", ip_cidr_range = var.app_services_secondary_cidr },
  ]
}

resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# Subnets (web/app/db). Secondary ranges hanya untuk subnet app.
resource "google_compute_subnetwork" "subs" {
  for_each                 = { for s in var.subnets : s.name => s }
  name                     = each.value.name
  ip_cidr_range            = each.value.ip_cidr_range
  region                   = each.value.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true

  dynamic "secondary_ip_range" {
    for_each = can(regex("-app$", each.key)) ? local.app_secondary_ranges : []
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }

  depends_on = [google_compute_network.vpc]
}

# Cloud Router + NAT for egress
resource "google_compute_router" "router" {
  name    = "${var.network_name}-router"
  region  = var.region
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.network_name}-nat"
  router                             = google_compute_router.router.name
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
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [var.allow_ssh_cidr]
  target_tags   = ["allow-ssh"]
}

# Reserved range for Service Networking (Cloud SQL Private IP)
resource "google_compute_global_address" "psc_sql_range" {
  name          = "${var.network_name}-psc-sql-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}