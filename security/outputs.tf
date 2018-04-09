output "tux_sg_id" {
  value = "${module.tux_sg.this_security_group_id}"
}

output "win_sg_id" {
  value = "${module.win_sg.this_security_group_id}"
}
