output "vpc_name" {
  value = module.network.network_name
}

output "gke_endpoint" {
  value = module.gke.endpoint
}

output "gke_cluster_name" {
  value = module.gke.name
}

output "sql_connection_name" {
  value = module.sql.connection_name
}