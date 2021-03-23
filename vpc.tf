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

### Public subnet declaration
# Demo VPC uses two Public subnets by default (see Variables.tf)
resource "aws_subnet" "vpc_public_subnets" {
  vpc_id = aws_vpc.vpc_name.id
  count = length(var.vpc_private_subnet_cidrs)
  cidr_block = element(var.vpc_public_subnet_cidrs, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index % 2)
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-public-${var.vpc_name}-${count.index}"
  }
}

### Private subnets declaration
# Demo VPC uses two Private subnets by default (see Variables.tf)
resource "aws_subnet" "vpc_private_subnets" {
  vpc_id = aws_vpc.vpc_name.id
  count = length(var.vpc_private_subnet_cidrs)
  cidr_block = element(var.vpc_private_subnet_cidrs, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index % 2)
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-private-${var.vpc_name}-${count.index}"
  }
}

### Internet gateway for the public subnets
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc_name.id
  
  tags = {
    Name = "igw-${var.vpc_name}"
  }
}

### Elastic IP for each NAT gateway
resource "aws_eip" "nat_private_ips" {
  count = length(var.vpc_private_subnet_cidrs)
  vpc   = true
}

### NAT gateways
resource "aws_nat_gateway" "nat_private" {
  depends_on = [aws_internet_gateway.vpc_igw]
  count = length(var.vpc_private_subnet_cidrs)
  allocation_id = element(aws_eip.nat_private_ips.*.id, count.index)
  subnet_id = element(aws_subnet.vpc_public_subnets.*.id, count.index)
 
  tags = {
    Name = "nat-${var.vpc_name}-${count.index}"
  }
}

### Routing tables
resource "aws_route_table" "igw_route_public" {
  count = length(var.vpc_public_subnet_cidrs)
  vpc_id = aws_vpc.vpc_name.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }
  
  tags = {
    Name = "rt-public-internet-${var.vpc_name}"
  }
}

resource "aws_route_table" "nat_route_private" {
  count = length(var.vpc_private_subnet_cidrs)
  vpc_id = aws_vpc.vpc_name.id
  
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat_private.*.id, count.index)
  }
  
  tags = {
    Name = "rt-private-nat-${var.vpc_name}-${count.index}"
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

### Security Groups
resource "aws_security_group" "centrify_connector_sg" {
  name = "centrify_connector_sg"
  description = "Centrify Connector security group"
  vpc_id = aws_vpc.vpc_name.id

  ingress {
    # allow API Proxy calls from VPC subnets
	from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = flatten([var.vpc_public_subnet_cidrs, var.vpc_private_subnet_cidrs])
  }

  ingress {
    # allow IWA Service from VPC subnets
	from_port = 8433
    to_port = 8433
    protocol = "tcp"
    cidr_blocks = flatten([var.vpc_public_subnet_cidrs, var.vpc_private_subnet_cidrs])
  }

  ingress {
    # allow Centrify SSH Gateway from anywhere
	from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # allow Centrify RDP Gateway from anywhere
	from_port = 5555
    to_port = 5555
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    # allow all outbound traffic
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Centrify Connector"
  }
}

resource "aws_security_group" "vpc_public_sg" {
  name = "vpc_public_sg"
  description = "Public subnet security group"
  vpc_id = aws_vpc.vpc_name.id

  ingress {
    # allow ICMP from Centrify Connectors
    from_port = 8
    to_port = 0
    protocol = "icmp"
    security_groups = [aws_security_group.centrify_connector_sg.id]
  }

  ingress {
    # allow SSH from Centrify Connectors
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.centrify_connector_sg.id]
  }

  ingress {
    # allow RDP from Centrify Connectors
    from_port = 3389
    to_port = 3389
    protocol = "tcp"
    security_groups = [aws_security_group.centrify_connector_sg.id]
  }

  ingress {
    # allow WinRM-HTTP from Centrify Connectors
    from_port = 5985
    to_port = 5985
    protocol = "tcp"
    security_groups = [aws_security_group.centrify_connector_sg.id]
  }

  ingress {
    # allow WinRM-HTTPS from Centrify Connectors
    from_port = 5986
    to_port = 5986
    protocol = "tcp"
    security_groups = [aws_security_group.centrify_connector_sg.id]
  }

  egress {
    # allow all outbound traffic
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_security_group" "vpc_private_sg" {
  name = "vpc_private_sg"
  description = "Private ports accesss security group"
  vpc_id = aws_vpc.vpc_name.id

  ingress {
    # allow ICMP from Centrify Connectors
    from_port = 8
    to_port = 0
    protocol = "icmp"
    security_groups = [aws_security_group.centrify_connector_sg.id]
  }

  ingress {
    # allow SSH from Centrify Connectors
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.centrify_connector_sg.id]
  }

  ingress {
    # allow RDP from Centrify Connectors and RDP Gateways
    from_port = 3389
    to_port = 3389
    protocol = "tcp"
    security_groups = [aws_security_group.centrify_connector_sg.id]
  }

  ingress {
    # allow WinRM-HTTP from Centrify Connectors
    from_port = 5985
    to_port = 5985
    protocol = "tcp"
    security_groups = [aws_security_group.centrify_connector_sg.id]
  }

  ingress {
    # allow WinRM-HTTPS from Centrify Connectors
    from_port = 5986
    to_port = 5986
    protocol = "tcp"
    security_groups = [aws_security_group.centrify_connector_sg.id]
  }

  egress {
    # allow all outbound traffic
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "Private Subnet"
  }
}