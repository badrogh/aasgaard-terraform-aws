# VPC Security Groups
resource "aws_security_group" "centrify_connector_sg" {
  name = "centrify_connector_sg"
  description = "Centrify Connector security group"
  vpc_id = aws_vpc.vpc_name.id

  ingress {
    # allow API Proxy calls from VPC subnets
	from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [vpc_public_subnet_cidr, vpc_private_subnet_cidr]
  }

  ingress {
    # allow IWA Service from VPC subnets
	from_port = 8433
    to_port = 8433
    protocol = "tcp"
    cidr_blocks = [vpc_public_subnet_cidr, vpc_private_subnet_cidr]
  }

  ingress {
    # allow SSH Gateway from anywhere
	from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # allow SSH Gateway from anywhere
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
    Name = "${var.vpc_name}-public-sg"
  }
}

resource "aws_security_group" "vpc_public_sg" {
  name = "public-sg"
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
    Name = "${var.vpc_name}-public-sg"
  }
}

resource "aws_security_group" "vpc_private_sg" {
  name = "private-sg"
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
    Name = "${var.vpc_name}-private-sg"
  }
}
