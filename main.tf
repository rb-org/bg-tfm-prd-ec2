provider "aws" {
  version                 = "~> 1.9.0"
  region                  = "${var.region}"
  shared_credentials_file = "~/.aws/credentials"
}

provider "template" {
  version = ">= 1.0"
}


module "web_tier" {
  source = "./web_tier/"

  region                = "${var.region}"
  name_prefix           = "${var.name_prefix}"
  key_name              = "${var.key_name}"
  environment           = "${var.environment}"
  default_tags          = "${var.default_tags}"
  vpc_id                = "${data.terraform_remote_state.network.vpc_id}"
  vpc_cidr              = "${var.vpc_cidr}"
  web_asg_ami_blu       = "${var.bg-web-ws-ami_blu}"
  web_asg_ami_grn       = "${var.bg-web-ws-ami_grn}"
  web_asg_inst          = "${var.web_asg_inst}"
  private_subnets       = ["${data.terraform_remote_state.network.private_subnet_cidrs}"]
  web_asg_min           = "${var.web_asg_min}"
  web_asg_max           = "${var.web_asg_max}"
  web_asg_des_blu       = "${var.bg-web-ws-des_blu}"
  web_asg_des_grn       = "${var.bg-web-ws-des_grn}"
  userdata_file_web_blu = "${var.userdata_file_web_blu}"
  app_version_web_blu   = "${var.app_version_web_blu}"
  userdata_file_web_grn = "${var.userdata_file_web_grn}"
  app_version_web_grn   = "${var.app_version_web_grn}"
  iam_instance_profile  = "${module.iam.default_profile_name}"
  allowed_ips           = "${var.allowed_ips}"
  alb_web_sg_id         = "${module.load_balancers.alb_web_sg_id}"
  #alb_web_tg_arn        = "${module.load_balancers.alb_web_tg_arn}"
  win_sg_id             = "${module.security.win_sg_id}"

  #alb_web_sg_id  = "${data.terraform_remote_state.network.alb_web_sg_id}"
  alb_web_tg_arns = "${module.load_balancers.alb_web_tg_arns}"
  alb_web_tg_names = "${module.load_balancers.alb_web_tg_names}"
}

module "iam" {
  source = "./iam/"

  name_prefix = "${var.name_prefix}"
}

module "security" {
  source = "./security"

  name_prefix  = "${var.name_prefix}"
  environment  = "${var.environment}"
  allowed_ips  = ["${var.allowed_ips}"]
  vpc_id       = "${data.terraform_remote_state.network.vpc_id}"
  vpc_cidr     = "${var.vpc_cidr}"
  default_tags = "${var.default_tags}"
}

module "load_balancers" {
  source = "./load_balancers"

  name_prefix       = "${var.name_prefix}"
  environment       = "${var.environment}"
  allowed_ips       = ["${var.allowed_ips}"]
  vpc_id            = "${data.terraform_remote_state.network.vpc_id}"
  vpc_cidr          = "${var.vpc_cidr}"
  default_tags      = "${var.default_tags}"
  cert_domain       = "${var.cert_domain}"
  public_subnet_ids = "${data.terraform_remote_state.network.public_subnet_ids}"
}
