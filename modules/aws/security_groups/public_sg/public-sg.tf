variable "vpc_id" {}

resource "aws_security_group" "public" {
  name = "terraform"
  description = "Allow ssh from my Ip"
  vpc_id = "${var.vpc_id}"

  
   ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["195.204.41.10/32"]
  }
 
    ingress {
      from_port = 3389
      to_port = 3389
      protocol = "tcp"
      cidr_blocks = ["195.204.41.10/32"]
  }
  
    ingress {
      from_port = -1
      to_port = -1
      protocol = "icmp"
      cidr_blocks = ["195.204.41.10/32"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

output "id" {
	value = "${aws_security_group.public.id}"
}