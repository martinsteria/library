variable "subnet_id" {}
variable "routetable_id" {}


resource "aws_route_table_association" "a" {
    subnet_id = "${var.subnet_id}"
    route_table_id = "${var.routetable_id}"
}

output "id" {
	value = "${aws_route_table_association.a.id}"
}