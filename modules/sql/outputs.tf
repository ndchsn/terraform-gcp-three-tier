output "connection_name" {
  value = google_sql_database_instance.mysql.connection_name
}

output "db_user" {
  value = google_sql_user.user.name
}

output "db_password" {
  value     = random_password.db_pass.result
  sensitive = true
}