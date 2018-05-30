output "default_profile_name" {
  value = "${module.default_iam_role.instance_profile_name}"
}

output "default_role_name" {
  value = "${module.default_iam_role.instance_role_name}"
}
