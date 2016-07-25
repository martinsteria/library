variable "count" {
	default = "1"
}
variable "name" {}
variable "ami" {}
variable "type" {}
variable "subnet_id" {}
variable "key" {}
variable "sg_id" {}

resource "aws_instance" "instances" {
	count = "${var.count}"
	ami = "${var.ami}"
	instance_type = "${var.type}"
	subnet_id = "${var.subnet_id}"
	key_name = "${var.key}"
	vpc_security_group_ids = ["${var.sg_id}"]	
	tags {
		name ="${var.name}-${count.index}"
	}
}

output "IP" {
  value = "${aws_instance.instances.public_ip}"
}