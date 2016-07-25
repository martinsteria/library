variable "name" {} 
variable "description" {}


resource "aws_security_group" "SG" {
  name = "${var.name}"
  description = "${var.description}"
}

output "id" {
	value = "${aws_security_group.SG.id}"
}