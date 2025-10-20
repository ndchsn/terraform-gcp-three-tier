variable "project_id" { type = string }
variable "region"     { type = string }
variable "zone"       { type = string }

variable "env" {
  description = "Environment name: dev, stg, prod"
  type        = string
}

variable "network_name" {
  description = "VPC name"
  type        = string
  default     = "vpc-main"
}

variable "tier_cidrs" {
  description = "CIDR per tier and env"
  type = object({
    web = string
    app = string
    db  = string
  })
}

variable "gke" {
  description = "GKE settings"
  type = object({
    cluster_name     = string
    release_channel  = string
    min_nodes        = number
    max_nodes        = number
    machine_type     = string
    kubernetes_version = optional(string)
  })
}

variable "sql" {
  description = "Cloud SQL MySQL settings"
  type = object({
    instance_name    = string
    database_name    = string
    user_name        = string
    tier             = string
    disk_size_gb     = number
    availability_type = string
    database_version = string
  })
}

variable "tags_allow_ssh_cidr" {
  description = "Optional: your IP/CIDR to allow SSH temporarily (e.g. for bastion)"
  type        = string
  default     = null
}