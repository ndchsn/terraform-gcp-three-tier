output "network_name" {
  value = local.network_name_real
}

output "network_self_link" {
  value = local.network_self_link
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
  value = local.psc_sql_range_name_effective
}