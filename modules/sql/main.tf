# Service Networking connection for Private IP (managed only if manage_connection=true)
resource "google_service_networking_connection" "private_vpc_connection" {
  count                  = var.manage_connection ? 1 : 0
  network                = var.network_self_link
  service                = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [var.allocated_range_name]
}

resource "random_password" "db_pass" {
  length           = 16
  special          = true
  override_special = "!@#%^*-_=+"
}

resource "google_sql_database_instance" "mysql" {
  name             = var.instance_name
  region           = var.region
  database_version = var.database_version

  settings {
    tier      = var.tier
    disk_size = var.disk_size_gb
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_self_link
    }
    availability_type = var.availability_type
    backup_configuration {
      enabled = true
    }
  }

  deletion_protection = false

  depends_on = [google_service_networking_connection.private_vpc_connection]
}

resource "google_sql_database" "db" {
  name     = var.database_name
  instance = google_sql_database_instance.mysql.name
}

resource "google_sql_user" "user" {
  name     = var.user_name
  instance = google_sql_database_instance.mysql.name
  password = random_password.db_pass.result
}