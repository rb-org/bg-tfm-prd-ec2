variable "name_prefix" {}
variable "vpc_cidr" {}
variable "vpc_id" {}

variable "allowed_ips" {
  type = "list"
}

variable "environment" {}
variable "cert_domain" {}
variable "zone_id" {}

variable "default_tags" {
  type = "map"
}

variable "public_subnet_ids" {
  type = "list"
}

variable "www_dns_weight_blu" {}
variable "www_dns_weight_grn" {}

variable "r53_health_check_ranges" {
  default = [
    "54.241.32.64/26",
    "54.183.255.128/26",
    "107.23.255.0/26",
    "54.243.31.192/26",
    "216.182.238.0/23",
    "54.228.16.0/26",
    "176.34.159.192/26",
  ]
}
