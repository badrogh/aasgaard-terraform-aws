# Internet gateway for the public subnet
resource "aws_internet_gateway" "vpc_ig" {
  vpc_id = aws_vpc.vpc_name.id
  tags = {
    Name = "${var.vpc_name}-ig"
  }
}

# Public subnets
resource "aws_subnet" "vpc_public_sn" {
  vpc_id = aws_vpc.vpc_name.id
  cidr_block = var.vpc_public_subnet_cidr
  availability_zone = var.vpc_public_subnet_az
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}-public-sn"
  }
}

# Private subnets
resource "aws_subnet" "vpc_private_sn" {
  vpc_id = aws_vpc.vpc_name.id
  cidr_block = var.vpc_private_subnet_cidr
  availability_zone = var.vpc_private_subnet_az
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.vpc_name}-private-sn"
  }
}

# Routing table for public subnets
resource "aws_route_table" "vpc_public_sn_rt" {
  vpc_id = aws_vpc.vpc_name.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_ig.id
  }
  tags = {
    Name = "${var.vpc_name}-rt"
  }
}

# Associate the routing table to public subnets
resource "aws_route_table_association" "vpc_public_sn_rt_assn" {
  subnet_id = aws_subnet.vpc_public_sn.id
  route_table_id = aws_route_table.vpc_public_sn_rt.id
}
