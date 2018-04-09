// SG for Linux instances

// Security Group
module "tux_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "1.13.0"

  name   = "${var.name_prefix}-${lower(terraform.workspace)}-sg-tux"
  create = true
  vpc_id = "${var.vpc_id}"

  ingress_with_self = [
    {
      rule = "ssh-tcp"
    },
  ]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]

  tags = "${merge(var.default_tags, 
    map("Environment", format("%s", var.environment)), 
    map("Workspace", format("%s", terraform.workspace)),
    map("Name", format("%s-sg-tux", var.name_prefix))
    )
  }"
}

module "win_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "1.13.0"

  name   = "${var.name_prefix}-${lower(terraform.workspace)}-sg-win"
  create = true
  vpc_id = "${var.vpc_id}"

  ingress_with_self = [
    {
      rule = "rdp-tcp"
    },
  ]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]

  tags = "${merge(var.default_tags, 
    map("Environment", format("%s", var.environment)), 
    map("Workspace", format("%s", terraform.workspace)),
    map("Name", format("%s-sg-win", var.name_prefix))
    )
  }"
}
