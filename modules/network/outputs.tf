output "network_name" {
  value = google_compute_network.vpc.name
}

output "network_self_link" {
  value = google_compute_network.vpc.self_link
}

output "subnet_self_links" {
  value = { for k, v in google_compute_subnetwork.subs : k => v.self_link }
}

output "pods_range_name" {
  value = "pods-range"
}

output "svcs_range_name" {
  value = "services-range"
}

output "psc_sql_range_name" {
  value = google_compute_global_address.psc_sql_range.name
}