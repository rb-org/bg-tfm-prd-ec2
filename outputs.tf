output "alb_web_tg_arns" {
  value = ["${module.load_balancers.alb_web_tg_arns}"]
}

output "alb_web_tg_names" {
  value = ["${module.load_balancers.alb_web_tg_names}"]
}

output "default_profile_name" {
  value = "${module.iam.default_profile_name}"
}