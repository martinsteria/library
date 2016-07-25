variable "type" {}
variable "from_port" {}
variable "to_port" {}
variable "protocol" {}
variable "cidr" {}
variable "sg_id" {}


resource "aws_security_group_rule" "allow_all" {
    type = "${var.type}"
    from_port = "${var.from_port}"
    to_port = "${var.to_port}"
    protocol = "${var.protocol}"
    cidr_blocks = "${var.cidr}"
    security_group_id = "${var.sg_id}"
}