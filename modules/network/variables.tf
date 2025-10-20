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