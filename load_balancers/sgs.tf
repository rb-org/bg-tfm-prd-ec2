// ALB Security Group

module "alb_web_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "1.13.0"

  name   = "${var.name_prefix}-${terraform.workspace}-sg-web-alb"
  vpc_id = "${var.vpc_id}"

  // Ingree
  ingress_cidr_blocks = "${var.allowed_ips}"
  ingress_rules       = ["https-443-tcp"]

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
