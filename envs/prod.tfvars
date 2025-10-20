project_id = "mlpt-cloudteam-migration"
region     = "asia-southeast2"
zone       = "asia-southeast2-a"
env        = "prod"

network_name = "vpc-main"
# consume existing VPC; rely on NAT/PSC created by dev
network_create_network    = false
network_manage_router_nat = false
network_manage_psc        = false

tier_cidrs = {
  web = "10.2.1.0/24"
  app = "10.2.2.0/24"
  db  = "10.2.3.0/24"
}

gke = {
  cluster_name       = "gke-app-prod"
  release_channel    = "REGULAR"
  min_nodes          = 2
  max_nodes          = 5
  machine_type       = "e2-standard-4"
  kubernetes_version = null
}

sql = {
  instance_name     = "mysql-db-prod"
  database_name     = "appdb"
  user_name         = "appuser"
  tier              = "db-custom-2-7680"
  disk_size_gb      = 50
  availability_type = "REGIONAL"
  database_version  = "MYSQL_8_0"
}

tags_allow_ssh_cidr = null