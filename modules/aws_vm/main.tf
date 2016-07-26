#Virtual Machine
/**
Module Description = This module creates one instance with a public IP-address
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
	default = "10.0.0.0/16"
}
variable "vpc_name" {
	description = "The name of the VPC"
	default = "VPC"
}
variable "igw_name" {
	description = "The name of internet gateway"
	default = "IGW"
}
variable "subnet_cidr" {
	description = "The CIDR range of your private subnet"
	default = "10.0.1.0/24"
}
variable "ami" {
	description = "The AMI-id of your public instance. The AMI contains specifies the software configuration of the instance"	
	default = "ami-f9dd458a"
}
variable "type" {
	description = "The type of your public instance. The type specifies the hardware configuration of the instance"
	default = "t2.micro"
}
variable "key" {
	description = "The name of the ssh-key you want to assign to the public instance. The key need to exists already."
}

variable "numberOfPublicInstances" {
	description = "The number of instances with public IP-address"
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

module "public_instance" {
	source = "../aws/n-public-instances"
	count = "${var.numberOfPublicInstances}"
	vpc_id = "${module.VPC.id}"
	subnet_cidr = "${var.subnet_cidr}"
	igw_id = "${module.igw.id}"
	ami = "${var.ami}"
	type = "${var.type}"
	key = "${var.key}"
}

output "publicIP" {
  /*
  Output Description = "The public IP-address attached to the VM"
  */
  value = "${module.public_instance.IPAddress}"
}