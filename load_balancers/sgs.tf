// ALB Security Group

module "alb_web_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "1.20.0"

  name   = "${var.name_prefix}-${terraform.workspace}-sg-web-alb"
  vpc_id = "${var.vpc_id}"

  // Ingress
  # ingress_with_source_security_group_id = ["${module.r53_health_checks_sg.this_security_group_id}"]
  ingress_cidr_blocks = "${var.allowed_ips}"

  ingress_rules = ["https-443-tcp"]

  // Egress
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = "${merge(var.default_tags, 
    map("Environment", format("%s", var.environment)), 
    map("Workspace", format("%s", terraform.workspace)),
    map("Name", format("%s-sg-web-alb", var.name_prefix))
    )
  }"
}

module "r53_health_checks_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "1.20.0"

  name   = "${var.name_prefix}-${terraform.workspace}-sg-r53-health-checks"
  vpc_id = "${var.vpc_id}"

  // Ingress
  ingress_cidr_blocks = "${var.r53_health_check_ranges}"
  ingress_rules       = ["https-443-tcp"]

  // Egress
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = "${merge(var.default_tags, 
    map("Environment", format("%s", var.environment)), 
    map("Workspace", format("%s", terraform.workspace)),
    map("Name", format("%s-sg-r53-health-checks", var.name_prefix))
    )
  }"
}
