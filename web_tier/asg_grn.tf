module "asg_web_grn" {
  # source = "git::ssh://git@github.com/exactsoftware/xyz-tfm-mods-asg"
  source = "git@github.com:exactsoftware/xyz-tfm-mods-asg//asg"

  ami_id               = "${var.web_asg_ami_grn[var.region]}"
  instance_type        = "${var.web_asg_inst[terraform.workspace]}"
  iam_instance_profile = "${var.iam_instance_profile}"
  key_name             = "${var.key_name[var.region]}"

  //Using a reference to an SG we create in the same template.
  // - It needs to be customized based on the name of your module resource
  // - It is recommended that you use https://github.com/terraform-community-modules/tf_aws_sg/tree/master/sg_https_only
  //   for the SG
  security_group = ["${aws_security_group.asg_web_sg.id}"]

  user_data        = "${var.userdata_file_web_grn}"
  name             = "${var.name_prefix}-${terraform.workspace}-web-grn"
  asg_max_size     = "${var.web_asg_max[terraform.workspace]}"
  asg_min_size     = "${var.web_asg_min[terraform.workspace]}"
  desired_capacity = "${var.web_asg_des_grn}"

  #target_group_arns    = ["${var.alb_tg_arn}"]
  alb_target_group_arn = "${data.aws_lb_target_group.grn.arn}"
  vpc_zone_identifier  = ["${var.private_subnets}"]

  // The health_check_type can be EC2 or ELB and defaults to ELB
  health_check_type         = "EC2"
  health_check_grace_period = 3000
  default_cooldown          = 3000

  # availability_zones = ["${data.aws_availability_zones.all.names }"]
  app_role    = "web-server"
  app_id      = "web"
  app_version = "${var.app_version_web_grn}"
  svr_type    = "bg"
  offhours    = "off"
}
