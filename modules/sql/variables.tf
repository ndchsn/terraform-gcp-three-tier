variable "project_id"           { type = string }
variable "region"               { type = string }
variable "network_self_link"    { type = string }
variable "allocated_range_name" { type = string }

variable "instance_name"     { type = string }
variable "database_version"  { type = string }
variable "tier"              { type = string }
variable "disk_size_gb"      { type = number }
variable "availability_type" { type = string }

variable "database_name" { type = string }
variable "user_name"     { type = string }