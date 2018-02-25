// ALB Web Outputs 
output "alb_web_sg_id" {
  value = "${module.alb_web_sg.this_security_group_id}"
}

output "alb_web_id" {
  value = "${module.alb_web.alb_id}"
}

output "alb_web_tg_arns" {
  value = ["${module.alb_web.target_group_arns}"]
}

output "alb_web_tg_names" {
  value = ["${module.alb_web.target_group_names}"]
}

output "alb_web_dns_name" {
  value = "${module.alb_web.alb_dns_name}"
}

output "alb_web_zone_id" {
  value = "${module.alb_web.alb_zone_id}"
}
