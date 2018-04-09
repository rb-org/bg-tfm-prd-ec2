# Certificate & DNS 

data "aws_acm_certificate" "wildcard" {
  domain   = "*.${var.cert_domain}"
  statuses = ["ISSUED"]
}

data "aws_region" "current" {}

# ALB Web server 

module "alb_web_blu" {
  source  = "terraform-aws-modules/alb/aws"
  version = "2.5.0"

  alb_name                         = "${var.name_prefix}-${terraform.workspace}-alb-web-blu"
  alb_security_groups              = ["${module.alb_web_sg.this_security_group_id}"]
  certificate_arn                  = "${data.aws_acm_certificate.wildcard.arn}"
  health_check_path                = "/"
  subnets                          = ["${var.public_subnet_ids}"]
  vpc_id                           = "${var.vpc_id}"
  alb_protocols                    = ["HTTPS"]
  backend_port                     = "80"
  backend_protocol                 = "HTTP"
  cookie_duration                  = "1"
  health_check_healthy_threshold   = 3
  health_check_interval            = 300
  health_check_matcher             = "200-302"
  health_check_path                = "/"
  health_check_port                = "traffic-port"
  health_check_timeout             = 5
  health_check_unhealthy_threshold = 3
  security_policy                  = "ELBSecurityPolicy-TLS-1-2-2017-01"

  log_bucket_name     = "${var.name_prefix}-${terraform.workspace}-alb-web-blu-logs"
  log_location_prefix = "${data.aws_region.current.name}"
  enable_logging      = true
  create_log_bucket   = true

  tags = "${merge(var.default_tags, 
      map("Environment", format("%s", var.environment)), 
      map("Workspace", format("%s", terraform.workspace))
      )
    }"
}

module "alb_web_grn" {
  source  = "terraform-aws-modules/alb/aws"
  version = "2.5.0"

  alb_name                         = "${var.name_prefix}-${terraform.workspace}-alb-web-grn"
  alb_security_groups              = ["${module.alb_web_sg.this_security_group_id}"]
  certificate_arn                  = "${data.aws_acm_certificate.wildcard.arn}"
  health_check_path                = "/"
  subnets                          = ["${var.public_subnet_ids}"]
  vpc_id                           = "${var.vpc_id}"
  alb_protocols                    = ["HTTPS"]
  backend_port                     = "80"
  backend_protocol                 = "HTTP"
  cookie_duration                  = "1"
  health_check_healthy_threshold   = 3
  health_check_interval            = 300
  health_check_matcher             = "200-302"
  health_check_path                = "/"
  health_check_port                = "traffic-port"
  health_check_timeout             = 5
  health_check_unhealthy_threshold = 3
  security_policy                  = "ELBSecurityPolicy-TLS-1-2-2017-01"

  log_bucket_name     = "${var.name_prefix}-${terraform.workspace}-alb-web-grn-logs"
  log_location_prefix = "${data.aws_region.current.name}"
  enable_logging      = true
  create_log_bucket   = true

  tags = "${merge(var.default_tags, 
      map("Environment", format("%s", var.environment)), 
      map("Workspace", format("%s", terraform.workspace))
      )
    }"
}
