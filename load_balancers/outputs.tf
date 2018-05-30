// ALB Web Outputs 
output "alb_web_sg_id" {
  value = "${module.alb_web_sg.this_security_group_id}"
}

output "alb_web_blu_id" {
  value = "${module.alb_web_blu.alb_id}"
}

output "alb_web_blu_tg_arn" {
  value = "${module.alb_web_blu.target_group_arn}"
}

output "alb_web_blu_tg_name" {
  value = "${module.alb_web_blu.target_group_name}"
}

output "alb_web_blu_dns_name" {
  value = "${module.alb_web_blu.alb_dns_name}"
}

output "alb_web_blu_zone_id" {
  value = "${module.alb_web_blu.alb_zone_id}"
}

output "alb_web_grn_id" {
  value = "${module.alb_web_grn.alb_id}"
}

output "alb_web_grn_tg_arn" {
  value = "${module.alb_web_grn.target_group_arn}"
}

output "alb_web_grn_tg_name" {
  value = "${module.alb_web_grn.target_group_name}"
}

output "alb_web_grn_dns_name" {
  value = "${module.alb_web_grn.alb_dns_name}"
}

output "alb_web_grn_zone_id" {
  value = "${module.alb_web_grn.alb_zone_id}"
}
