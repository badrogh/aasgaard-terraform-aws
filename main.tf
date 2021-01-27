# Setup our aws provider
provider "aws" {
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  region = var.aws_region
}

# Define a vpc
resource "aws_vpc" "vpc_name" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}

# AMI selections
data "aws_ami" "windows_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*Windows_Server-2016-English-Full-Base*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

# Output
output "aws_region" {
  value = var.aws_region
}

output "vpc_id" {
  value = aws_vpc.vpc_name.id
}

output "vpc_public_sn_id" {
  value = aws_subnet.vpc_public_sn.id
}

output "vpc_private_sn_id" {
  value = aws_subnet.vpc_private_sn.id
}

output "vpc_public_sg_id" {
  value = aws_security_group.vpc_public_sg.id
}

output "vpc_private_sg_id" {
  value = aws_security_group.vpc_private_sg.id
}