# Setup our aws provider
provider "aws" {
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  region = var.vpc_region
}

# Define a vpc
resource "aws_vpc" "vpc_name" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}

# Internet gateway for the public subnet
resource "aws_internet_gateway" "vpc_ig" {
  vpc_id = aws_vpc.vpc_name.id
  tags = {
    Name = "${var.vpc_name}-ig"
  }
}

# Public subnet
resource "aws_subnet" "vpc_public_sn" {
  vpc_id = aws_vpc.vpc_name.id
  cidr_block = var.vpc_public_subnet_1_cidr
  availability_zone = lookup(var.availability_zone, var.vpc_region)
  tags = {
    Name = "${var.vpc_name}-public-sn"
  }
}

# Private subnet
resource "aws_subnet" "vpc_private_sn" {
  vpc_id = aws_vpc.vpc_name.id
  cidr_block = var.vpc_private_subnet_1_cidr
  availability_zone = lookup(var.availability_zone, var.vpc_region)
  tags = {
    Name = "${var.vpc_name}-private-sn"
  }
}

# Routing table for public subnet
resource "aws_route_table" "vpc_public_sn_rt" {
  vpc_id = aws_vpc.vpc_name.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_ig.id
  }
  tags = {
    Name = "${var.vpc_name}-rt"
  }
}

# Associate the routing table to public subnet
resource "aws_route_table_association" "vpc_public_sn_rt_assn" {
  subnet_id = aws_subnet.vpc_public_sn.id
  route_table_id = aws_route_table.vpc_public_sn_rt.id
}

# ECS Instance Security group
resource "aws_security_group" "vpc_public_sg" {
  name = "public-sg"
  description = "Public access security group"
  vpc_id = aws_vpc.vpc_name.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.vpc_access_from_ip_range]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = [var.vpc_public_subnet_1_cidr]
  }

  egress {
    # allow all traffic to private SN
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.vpc_name}-public-sg"
  }
}

resource "aws_security_group" "vpc_private_sg" {
  name = "private-sg"
  description = "Private ports accesss security group"
  vpc_id = aws_vpc.vpc_name.id

  # allow memcached port within VPC
  ingress {
    from_port = 11211
    to_port = 11211
    protocol = "tcp"
    cidr_blocks = [var.vpc_public_subnet_1_cidr]
  }

  # allow redis port within VPC
  ingress {
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    cidr_blocks = [var.vpc_public_subnet_1_cidr]
  }

  # allow postgres port within VPC
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = [var.vpc_public_subnet_1_cidr]
  }

  # allow mysql port within VPC
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = [var.vpc_public_subnet_1_cidr]
  }

  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.vpc_name}-private-sg"
  }
}

output "vpc_region" {
  value = var.vpc_region
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