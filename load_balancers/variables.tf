variable "name_prefix" {}
variable "vpc_cidr" {}
variable "vpc_id" {}

variable "allowed_ips" {
  type = "list"
}

variable "environment" {}
variable "cert_domain" {}

variable "default_tags" {
  type = "map"
}

variable "public_subnet_ids" {
  type = "list"
}
