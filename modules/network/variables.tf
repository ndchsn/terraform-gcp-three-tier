variable "project_id"   { type = string }
variable "region"       { type = string }
variable "network_name" { type = string }

variable "subnets" {
  description = "List of subnets to create"
  type = list(object({
    name          = string
    ip_cidr_range = string
    region        = string
  }))
}

variable "app_pods_secondary_cidr"     { type = string }
variable "app_services_secondary_cidr" { type = string }

variable "allow_ssh_cidr" {
  type    = string
  default = null
}

# Toggles to support consuming existing VPC
variable "create_network" {
  type        = bool
  description = "Create the VPC (true) or use an existing VPC (false)"
  default     = true
}
variable "manage_router_nat" {
  type        = bool
  description = "Create Cloud Router/NAT (true); else rely on existing"
  default     = true
}
variable "manage_psc" {
  type        = bool
  description = "Create reserved range for Service Networking (PSC) (true); else rely on existing"
  default     = true
}