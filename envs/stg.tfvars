project_id = "mlpt-cloudteam-migration"
region     = "asia-southeast2"
zone       = "asia-southeast2-a"
env        = "stg"

network_name = "vpc-main"

tier_cidrs = {
  web = "10.4.1.0/24"
  app = "10.4.2.0/24"
  db  = "10.4.3.0/24"
}

gke = {
  cluster_name       = "gke-app-stg"
  release_channel    = "REGULAR"
  min_nodes          = 1
  max_nodes          = 3
  machine_type       = "e2-standard-2"
  kubernetes_version = null
}

sql = {
  instance_name     = "mysql-db-stg"
  database_name     = "appdb"
  user_name         = "appuser"
  tier              = "db-custom-1-3840"
  disk_size_gb      = 20
  availability_type = "ZONAL"
  database_version  = "MYSQL_8_0"
}

tags_allow_ssh_cidr = null