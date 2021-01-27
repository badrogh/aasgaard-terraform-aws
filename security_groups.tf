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
    cidr_blocks = [var.vpc_public_subnet_cidr]
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
    cidr_blocks = [var.vpc_public_subnet_cidr]
  }

  # allow redis port within VPC
  ingress {
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    cidr_blocks = [var.vpc_public_subnet_cidr]
  }

  # allow postgres port within VPC
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = [var.vpc_public_subnet_cidr]
  }

  # allow mysql port within VPC
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = [var.vpc_public_subnet_cidr]
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
