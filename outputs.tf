output "alb_web_blu_tg_arn" {
  value = "${module.load_balancers.alb_web_blu_tg_arn}"
}

output "alb_web_blu_tg_name" {
  value = "${module.load_balancers.alb_web_blu_tg_name}"
}

output "alb_web_grn_tg_arn" {
  value = "${module.load_balancers.alb_web_grn_tg_arn}"
}

output "alb_web_grn_tg_name" {
  value = "${module.load_balancers.alb_web_grn_tg_name}"
}

output "default_profile_name" {
  value = "${module.iam.default_profile_name}"
}
