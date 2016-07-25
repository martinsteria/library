#Server Park 

/*
Module Description = The server park module creates a given number of virtual machines with one of them connected to a public IP-address
*/

variable "access_key" {
	description = "The access key to your AWS account"
}
variable "secret_key" {
	description = "The secret key to your AWS account"
}
variable "region" {
	description = "The geographical location of the VM"
    default = "eu-west-1"
}

variable "vpc_cidr" {
	description = "The CIDR range of your VPC"
}
variable "vpc_name" {
	description = "The name of the VPC"
	default = "VPC"
}
variable "igw_name" {
	description = "The name of internet gateway"
	default = "IGW"
}
variable "private_subnet_cidr" {
	description = "The CIDR range of your private subnet"
}
variable "public_subnet_cidr" {
	description = "The CIDR range of your public subnet"
}
variable "ami_public" {
	description = "The AMI-id of your public instance. The AMI contains specifies the software configuration of the instance"	
	default = "ami-f9dd458a"
}
variable "type_public" {
	description = "The type of your public instance. The type specifies the hardware configuration of the instance"
	default = "t2.micro"
}
variable "key_public" {
	description = "The name of the ssh-key you want to assign the to public instance. The key need to exists already."
}

variable "ami_private" {
	description = "The AMI-id of your private instance. The AMI contains specifies the software configuration of the instance"
	default = "ami-f9dd458a"	
}
variable "type_private" {
	description = "The type of your private instance. The type specifies the hardware configuration of the instance"
	default = "t2.micro"
}
variable "key_private" {
	description = "The name of the ssh-key you want to assign the to private instance. The key need to exists already."
}

variable "numberOfPrivateInstances" {
	description = "The number of private instances"
	default = "1"
}

provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

module "VPC" {
	source = "../../resources/aws_resources/VPC"
	cidr_block = "${var.vpc_cidr}"
	name = "${var.vpc_name}"
}

module "igw" {
	source = "../../resources/aws_resources/internet-gw"
    vpc_id = "${module.VPC.id}"
    name = "${var.igw_name}"
}

module "public-instance" {
	source = "../aws/n-public-instances"
	count = "1"
	vpc_id = "${module.VPC.id}"
	subnet_cidr = "${var.public_subnet_cidr}"
	igw_id = "${module.igw.id}"
	ami = "${var.ami_public}"
	type = "${var.type_public}"
	key = "${var.key_public}"
}

module "private-instances" {
	source = "../aws/n-private-instances-in-private-subnet"
	count = "${var.numberOfPrivateInstances}"
	subnet_cidr = "${var.private_subnet_cidr}"
	ami = "${var.ami_private}"
	type = "${var.type_private}"
	key = "${var.key_private}"
	vpc_id = "${module.VPC.id}"
}


output "publicIP" {
  /*
  Output Description = "The public IP-address attached to the VM"
  */
  value = "${module.public-instance.IPAddress}"
}