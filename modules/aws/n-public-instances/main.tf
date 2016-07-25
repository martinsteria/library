variable "count" {}
variable "vpc_id" {}
variable "subnet_cidr" {}
variable "igw_id" {}
variable "ami" {}
variable "type" {}
variable "key" {}

module "subnet" {
	source = "../../../resources/aws_resources/subnet"
	vpc_id = "${var.vpc_id}"
	cidr_block = "${var.subnet_cidr}"
	availability_zone = "eu-west-1a"
	public_ip = true
	name = "public_subnet"
}

module "routetable" {
	source = "../../../resources/aws_resources/routetable"
	vpc_id = "${var.vpc_id}"
	name = "public_routetable"
}

module "route" {
	source = "../../../resources/aws_resources/route"
	route_table_id = "${module.routetable.id}"
	igw_id = "${var.igw_id}"
	dest_cidr_block = "0.0.0.0/0"
}

module "route_table_association" {
	source = "../../../resources/aws_resources/route-table-association"
	subnet_id = "${module.subnet.id}"
	routetable_id = "${module.routetable.id}"
}

module "public_sg" {
	source = "../security_groups/public_sg"
	vpc_id="${var.vpc_id}"
}

module "publicInstance" {
	source = "../../../resources/aws_resources/instance"
	count = "${var.count}"
	ami = "${var.ami}"
	type = "${var.type}"
	subnet_id = "${module.subnet.id}"
	key = "${var.key}"
	sg_id =  "${module.public_sg.id}"
	name = "public instance"	
}

output "IPAddress" {
  /*
  Output Description = "The public IP-address attached to the VM"
  */
  value = "${module.publicInstance.IP}"
}