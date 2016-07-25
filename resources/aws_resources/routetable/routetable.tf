variable "vpc_id"{}
variable "name" {}


resource "aws_route_table" "routetable" {
    vpc_id = "${var.vpc_id}"
    tags {
        Name = "main"
    }
}

output "id" {
	value = "${aws_route_table.routetable.id}"
}