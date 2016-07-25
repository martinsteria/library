variable "cidr_block" {}
variable "name" {}


resource "aws_vpc" "vpc" {
    cidr_block = "${var.cidr_block}"
	
	 tags {
        Name = "${var.name}"
    }
}

output "id" {
	value = "${aws_vpc.vpc.id}"
}