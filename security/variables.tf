variable "name_prefix" {}
variable "vpc_cidr" {}
variable "vpc_id" {}

variable "allowed_ips" {
  type = "list"
}

variable "environment" {}

variable "default_tags" {
  type = "map"
}
