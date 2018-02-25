variable "name_prefix" {}
variable "region" {}
variable "environment" {}

variable "key_name" {
  type = "map"
}

variable "vpc_id" {}
variable "vpc_cidr" {}

variable "web_asg_inst" {
  type = "map"
}

variable "private_subnets" {
  type = "list"
}

variable "web_asg_min" {
  type = "map"
}

variable "web_asg_max" {
  type = "map"
}

variable "web_asg_des_blu" {}

variable "web_asg_des_grn" {}

variable "web_asg_ami_blu" {
  type = "map"
}

variable "web_asg_ami_grn" {
  type = "map"
}

variable "userdata_file_web_blu" {}

variable "app_version_web_blu" {}

variable "userdata_file_web_grn" {}

variable "app_version_web_grn" {}

variable "iam_instance_profile" {}

variable "allowed_ips" {
  type = "list"
}

variable "alb_web_tg_arns" {
  type = "list"
}

variable "alb_web_tg_names" {
  type = "list"
}

variable "alb_web_sg_id" {}

variable "win_sg_id" {}

variable "default_tags" {
  type = "map"
}
