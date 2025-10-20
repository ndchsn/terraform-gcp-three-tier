variable "project_id"           { type = string }
variable "region"               { type = string }
variable "network_self_link"    { type = string }
variable "allocated_range_name" { type = string }
variable "manage_connection" {
  description = "Create/delete Service Networking connection (true only in dev)"
  type        = bool
  default     = true
}

variable "instance_name"     { type = string }
variable "database_version"  { type = string }
variable "tier"              { type = string }
variable "disk_size_gb"      { type = number }
variable "availability_type" { type = string }

variable "database_name" { type = string }
variable "user_name"     { type = string }