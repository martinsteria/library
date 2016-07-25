variable "vpc_id" {}
variable "name" {}


resource "aws_internet_gateway" "igw" {
    vpc_id = "${var.vpc_id}"
    tags {
        Name = "${var.name}"
    }
}

output "id" {
	value = "${aws_internet_gateway.igw.id}"
}