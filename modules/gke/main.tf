resource "google_container_cluster" "this" {
  name     = var.cluster_name
  location = var.region
  network  = var.network
  subnetwork = var.subnetwork

  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false

  release_channel {
    channel = var.release_channel
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.ip_range_pods_name
    services_secondary_range_name = var.ip_range_services_name
  }

  networking_mode = "VPC_NATIVE"

  # Public control plane, nodes private optional (not enabled here for simplicity)
  # private_cluster_config { enable_private_nodes = true ... }  -- future enhancement

  # If version provided
  dynamic "cluster_autoscaling" {
    for_each = []
    content {}
  }

  lifecycle {
    ignore_changes = [node_config, node_pool, initial_node_count]
  }
}

resource "google_container_node_pool" "default" {
  name       = "default-pool"
  location   = var.region
  cluster    = google_container_cluster.this.name

  node_count = var.nodepool.min_nodes

  autoscaling {
    min_node_count = var.nodepool.min_nodes
    max_node_count = var.nodepool.max_nodes
  }

  node_config {
    machine_type = var.nodepool.machine_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
    tags = ["gke-node"]
    labels = {
      env = "default"
    }
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}