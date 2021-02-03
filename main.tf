### Setup our AWS provider
#
provider "aws" {
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  region = var.aws_region
}

### Main VPC declaration
# Note that demo VPC uses 10.0.0.0/16 CIDR block by default (see Variables.tf)
#
resource "aws_vpc" "vpc_name" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}

data "aws_availability_zones" "available" {
	state = "available"
}

#locals {
#	public_subnets = aws_subnet.vpc_public_subnets.*.id
#	private_subnets = aws_subnet.vpc_private_subnets.*.id
#}

resource "random_id" "server_name" {
  byte_length = 8
}

### AMI selections
# Use this section to list out the AMI to use for instances creation
data "aws_ami" "windows_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*Windows_Server-2019-English-Full-Base*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}
