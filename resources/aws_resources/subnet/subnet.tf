variable "vpc_id" {}
variable "cidr_block" {}
variable "availability_zone" {}
variable "public_ip" {}
variable "name" {}
variable "count" {
	default = 2
}

resource "aws_subnet" "subnet" {
    vpc_id = "${var.vpc_id}"
    cidr_block = "${cidrsubnet(var.cidr_block, 4, count.index)}"
	availability_zone = "${var.availability_zone}"
	map_public_ip_on_launch = "${var.public_ip}"

    tags {
        name = "${var.name}"
    }
}

output "id" {
	value = "${aws_subnet.subnet.id}"
}