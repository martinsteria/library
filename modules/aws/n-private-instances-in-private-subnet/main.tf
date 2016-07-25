variable "count" {
	default = "1"
}
variable "ami" {}
variable "type" {}
variable "key" {}
variable "vpc_id" {}
variable "subnet_cidr" {}

module "subnet" {
	source = "../../../resources/aws_resources/subnet"
	vpc_id = "${var.vpc_id}"
	cidr_block = "${var.subnet_cidr}"
	availability_zone = "eu-west-1a"
	public_ip = false
	name = "private_subnet"
}

module "private_sg" {
	source = "../security_groups/private_sg"
	vpc_id="${var.vpc_id}"
}

module "private_instances" {
	source = "../../../resources/aws_resources/instance"
	count = "${var.count}"
	name = "private instance"
	subnet_id = "${module.subnet.id}"
	sg_id =  "${module.private_sg.id}"
	ami = "${var.ami}"
	type = "${var.type}"
	key = "${var.key}"
}