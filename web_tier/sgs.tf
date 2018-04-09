// Security Group Resource for Module
resource "aws_security_group" "asg_web_sg" {
  name        = "${var.name_prefix}-${terraform.workspace}-sg-web-asg"
  description = "Security Group ${var.name_prefix}-${terraform.workspace}-sg-asg-web"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name        = "${var.name_prefix}-${terraform.workspace}-sg-web-asg"
    Terraform   = "true"
    Environment = "${terraform.workspace}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// allows traffic for TCP 80 (HTTP)
resource "aws_security_group_rule" "allow_http_web" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  #cidr_blocks     = ["0.0.0.0/0"]
  #prefix_list_ids = ["pl-12c4e678"]  
  security_group_id = "${aws_security_group.asg_web_sg.id}"

  source_security_group_id = "${var.alb_web_sg_id}"
}

// allow traffic for TCP 22 (SSH)
resource "aws_security_group_rule" "allow_ssh_web" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  cidr_blocks = ["${var.vpc_cidr}"]

  #prefix_list_ids = ["pl-12c4e678"]  
  security_group_id = "${aws_security_group.asg_web_sg.id}"

  #source_security_group_id = "${var.source_sg_id_ssh}"
}

// allow traffic for TCP 3389 (RDP)
resource "aws_security_group_rule" "allow_rdp_web" {
  type      = "ingress"
  from_port = 3389
  to_port   = 3389
  protocol  = "tcp"

  cidr_blocks = ["${var.vpc_cidr}"]

  #prefix_list_ids = ["pl-12c4e678"]  
  security_group_id = "${aws_security_group.asg_web_sg.id}"

  #source_security_group_id = "${var.source_sg_id_ssh}"
}
