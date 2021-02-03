### Public subnet declaration
# Demo VPC uses two Public subnets by default (see Variables.tf)
#
resource "aws_subnet" "vpc_public_subnets" {
  vpc_id = aws_vpc.vpc_name.id
  count = length(var.vpc_private_subnet_cidrs)
  cidr_block = element(var.vpc_public_subnet_cidrs, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index % 2)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-sn-${random_id.instance.hex}"
  }
}

### Private subnets declaration
# Demo VPC uses two Private subnets by default (see Variables.tf)
#
resource "aws_subnet" "vpc_private_subnets" {
  vpc_id = aws_vpc.vpc_name.id
  count = length(var.vpc_private_subnet_cidrs)
  cidr_block = element(var.vpc_private_subnet_cidrs, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index % 2)
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.vpc_name}-private-sn-${random_id.instance.hex}"
  }
}

### Internet gateway for the public subnets
#
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc_name.id
  
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

### Elastic IP for each NAT gateway
resource "aws_eip" "nat_private_ips" {
  count = length(var.vpc_private_subnet_cidrs)
  vpc   = true
}

### NAT gateways
resource "aws_nat_gateway" "nat_gw_private" {
  depends_on = [aws_internet_gateway.vpc_igw]
  count = length(var.vpc_private_subnet_cidrs)
  allocation_id = element(aws_eip.nat_private_ips.*.id, count.index)
  subnet_id = element(aws_subnet.vpc_public_subnets.*.id, count.index)
}

### Routing tables
#
resource "aws_route_table" "igw_route_public" {
  count = length(var.vpc_public_subnet_cidrs)
  vpc_id = aws_vpc.vpc_name.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }
  
  tags = {
    Name = "${var.vpc_name}-public-internet-rt"
  }
}

resource "aws_route_table" "nat_route_private" {
  count = length(var.vpc_private_subnet_cidrs)
  vpc_id = aws_vpc.vpc_name.id
  
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat_gw_private.*.id, count.index)
  }
  
  tags = {
    Name = "${var.vpc_name}-private-nat-rt-${random_id.instance.hex}"
  }
}

resource "aws_route_table_association" "vpc_public_routes" {
  count = length(var.vpc_public_subnet_cidrs)
  subnet_id = element(aws_subnet.vpc_public_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.igw_route_public.*.id, count.index)
}

resource "aws_route_table_association" "vpc_private_routes" {
  count = length(var.vpc_public_subnet_cidrs)
  subnet_id = element(aws_subnet.vpc_private_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.nat_route_private.*.id, count.index)
}
