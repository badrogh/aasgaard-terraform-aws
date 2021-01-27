# VPC Security Groups
resource "aws_security_group" "centrify_connector_sg" {
  name = "centrify_connector_sg"
  description = "Centrify Connector security group"
  vpc_id = aws_vpc.vpc_name.id

  ingress {
    # allow API Proxy port from VPC subnets
	from_port = 8080
    to_port = 8080
    protocol = "tcp"
    security_groups = [aws_security_group.vpc_public_sg, aws_security_group.vpc_private_sg]
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
    from_port = 0
    to_port = 0
    protocol = "icmp"
    security_groups = [aws_security_group.centrify_connector_sg]
  }

  ingress {
    # allow SSH from Centrify Connectors
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.centrify_connector_sg]
  }

  ingress {
    # allow RDP from Centrify Connectors
    from_port = 3389
    to_port = 3389
    protocol = "tcp"
    security_groups = [aws_security_group.centrify_connector_sg]
  }

  ingress {
    # allow WinRM-HTTP from Centrify Connectors
    from_port = 5985
    to_port = 5985
    protocol = "tcp"
    security_groups = [aws_security_group.centrify_connector_sg]
  }

  ingress {
    # allow WinRM-HTTPS from Centrify Connectors
    from_port = 5986
    to_port = 5986
    protocol = "tcp"
    security_groups = [aws_security_group.centrify_connector_sg]
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
    from_port = 0
    to_port = 0
    protocol = "icmp"
    security_groups = [aws_security_group.centrify_connector_sg]
  }

  ingress {
    # allow SSH from Centrify Connectors
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.centrify_connector_sg]
  }

  ingress {
    # allow RDP from Centrify Connectors
    from_port = 3389
    to_port = 3389
    protocol = "tcp"
    security_groups = [aws_security_group.centrify_connector_sg]
  }

  ingress {
    # allow WinRM-HTTP from Centrify Connectors
    from_port = 5985
    to_port = 5985
    protocol = "tcp"
    security_groups = [aws_security_group.centrify_connector_sg]
  }

  ingress {
    # allow WinRM-HTTPS from Centrify Connectors
    from_port = 5986
    to_port = 5986
    protocol = "tcp"
    security_groups = [aws_security_group.centrify_connector_sg]
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
