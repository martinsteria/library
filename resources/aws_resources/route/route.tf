variable "igw_id" {}
variable "dest_cidr_block" {}
variable "route_table_id" {}

resource "aws_route" "route" {
	route_table_id = "${var.route_table_id}"
	destination_cidr_block = "${var.dest_cidr_block}"
	gateway_id =  "${var.igw_id}"
}

output "id" {
	value = "${aws_route.route.id}"
}