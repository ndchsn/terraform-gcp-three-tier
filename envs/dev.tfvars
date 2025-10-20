project_id = "mlpt-cloudteam-migration"
region     = "asia-southeast2"
zone       = "asia-southeast2-a"
env        = "dev"

network_name = "vpc-main"

tier_cidrs = {
  web = "10.3.1.0/24"
  app = "10.3.2.0/24"
  db  = "10.3.3.0/24"
}

gke = {
  cluster_name       = "gke-app-dev"
  release_channel    = "REGULAR"
  min_nodes          = 1
  max_nodes          = 3
  machine_type       = "e2-standard-2"
  kubernetes_version = null
}

# Choose non-overlapping secondary ranges for GKE (dev)
app_pods_secondary_cidr     = "10.30.0.0/16"
app_services_secondary_cidr = "10.31.0.0/20"

sql = {
  instance_name     = "mysql-db-dev"
  database_name     = "appdb"
  user_name         = "appuser"
  tier              = "db-custom-1-3840"
  disk_size_gb      = 20
  availability_type = "ZONAL"
  database_version  = "MYSQL_8_0"
}

# put your IP/CIDR or leave null to skip SSH rule
tags_allow_ssh_cidr = null