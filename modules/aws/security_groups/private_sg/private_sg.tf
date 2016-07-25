variable "vpc_id" {}

resource "aws_security_group" "private" {
  name = "terraform_private"
  description = "Allow ssh from all ips"
  vpc_id = "${var.vpc_id}"

  
   ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
 
    ingress {
      from_port = 3389
      to_port = 3389
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  
    ingress {
      from_port = -1
      to_port = -1
      protocol = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

output "id" {
	value = "${aws_security_group.private.id}"
}