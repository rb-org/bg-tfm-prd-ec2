variable "name_prefix" {
  default = "bg" # This should be shortened to exol when moving to a live
}

variable "region" {}
variable "vpc_cidr" {}
variable "acc_id" {}
variable "environment" {}

variable "default_tags" {
  description = "Map of tags to add to all resources"
  type        = "map"

  default = {
    Terraform          = "true"
    GitHubRepo         = "bg-tfm-prd-ec2"
    GitHubOrganization = "rb-org"
  }
}

variable "az_count" {
  default = 2
}

variable "key_name" {
  type = "map"
}

variable "allowed_ips" {
  type = "list"
  default = ["0.0.0.0/0"]
}

variable "cert_domain" {}

// Web Tier

variable "app_version_web_blu" {}
variable "app_version_web_grn" {}
variable "bg-web-ws-des_blu" {}
variable "bg-web-ws-des_grn" {}

variable "bg-web-ws-ami_blu" {
  type = "map"
}

variable "bg-web-ws-ami_grn" {
  type = "map"
}

variable "web_asg_inst" {
  type = "map"

  default = {
    d202 = "t2.medium"
    t201 = "t2.medium"
  }
}

variable "web_asg_min" {
  type = "map"

  default = {
    d202 = 0
    t201 = 0
  }
}

variable "web_asg_max" {
  type = "map"

  default = {
    d202 = 1
    t201 = 1
  }
}

variable "userdata_file_web_blu" {
  default = "./files/userdata_asg_blu.ps1"
}

variable "userdata_file_web_grn" {
  default = "./files/userdata_asg_grn.ps1"
}

// Jump Hosts

variable "rdp_ami_id" {
  type = "map"

  default = {
    eu-west-1 = "ami-96b824ef"
  }
}

variable "ssh_ami_id" {
  type = "map"

  default = {
    eu-west-1 = "ami-4d46d534"
  }
}
