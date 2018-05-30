# B/G ALB DNS Records

resource "aws_route53_record" "blu" {
  zone_id = "${var.zone_id}"
  name    = "ws-blu.${var.cert_domain}"
  type    = "A"

  alias {
    name                   = "${module.alb_web_blu.alb_dns_name}"
    zone_id                = "${module.alb_web_blu.alb_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "grn" {
  zone_id = "${var.zone_id}"
  name    = "ws-grn.${var.cert_domain}"
  type    = "A"

  alias {
    name                   = "${module.alb_web_grn.alb_dns_name}"
    zone_id                = "${module.alb_web_grn.alb_zone_id}"
    evaluate_target_health = true
  }
}

# B/G ALB DNS Health Checks

resource "aws_route53_health_check" "blu" {
  fqdn              = "ws-blu.${var.cert_domain}"
  port              = 443
  type              = "HTTPS"
  resource_path     = "/"
  failure_threshold = "5"
  request_interval  = "30"
  regions           = ["eu-west-1", "us-west-1", "us-east-1"]

  tags = {
    Name = "ws-blu.${var.cert_domain}-health-check"
  }
}

resource "aws_route53_health_check" "grn" {
  fqdn              = "ws-grn.${var.cert_domain}"
  port              = 443
  type              = "HTTPS"
  resource_path     = "/"
  failure_threshold = "5"
  request_interval  = "30"
  regions           = ["eu-west-1", "us-west-1", "us-east-1"]

  tags = {
    Name = "ws-grn.${var.cert_domain}-health-check"
  }
}

# DNS Weighted Routing 

resource "aws_route53_record" "www_blu" {
  zone_id = "${var.zone_id}"
  name    = "www"
  type    = "CNAME"
  ttl     = "5"

  weighted_routing_policy {
    weight = "${var.www_dns_weight_blu}"
  }

  set_identifier  = "www-blu"
  records         = ["ws-blu.${var.cert_domain}"]
  health_check_id = "${aws_route53_health_check.blu.id}"
}

resource "aws_route53_record" "www_grn" {
  zone_id = "${var.zone_id}"
  name    = "www"
  type    = "CNAME"
  ttl     = "5"

  weighted_routing_policy {
    weight = "${var.www_dns_weight_grn}"
  }

  set_identifier  = "www-grn"
  records         = ["ws-grn.${var.cert_domain}"]
  health_check_id = "${aws_route53_health_check.grn.id}"
}
