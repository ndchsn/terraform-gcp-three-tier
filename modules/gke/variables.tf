variable "project_id"             { type = string }
variable "region"                 { type = string }
variable "network"                { type = string }
variable "subnetwork"             { type = string }
variable "ip_range_pods_name"     { type = string }
variable "ip_range_services_name" { type = string }

variable "cluster_name"       { type = string }
variable "release_channel"    { type = string }
variable "kubernetes_version" {
  type    = string
  default = null
}

variable "nodepool" {
  type = object({
    min_nodes    = number
    max_nodes    = number
    machine_type = string
  })
}