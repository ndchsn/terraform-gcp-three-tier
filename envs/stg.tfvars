project_id = "mlpt-cloudteam-migration"
region     = "asia-southeast2"
zone       = "asia-southeast2-a"
env        = "stg"

network_name = "vpc-main"
# consume existing VPC; rely on NAT/PSC created by dev
network_create_network    = false
network_manage_router_nat = false
network_manage_psc        = false

tier_cidrs = {
  web = "10.4.1.0/24"
  app = "10.4.2.0/24"
  db  = "10.4.3.0/24"
}

gke = {
  cluster_name       = "gke-app-stg"
  release_channel    = "REGULAR"
  min_nodes          = 2
  max_nodes          = 4
  machine_type       = "e2-standard-2"
  kubernetes_version = null
}

# Choose non-overlapping secondary ranges for GKE (stg)
app_pods_secondary_cidr     = "10.32.0.0/16"
app_services_secondary_cidr = "10.33.0.0/20"

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