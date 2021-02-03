resource "aws_instance" "rdp_gateway" {
  depends_on = [aws_nat_gateway.nat_gw_private, aws_subnet.vpc_public_subnets]
  
  # Deploy 1 RDP Gateway per public subnet
  count = length(aws_subnet.vpc_public_subnets.*.id)
  
  # Instance type
  ami = data.aws_ami.windows_ami.id
  instance_type = var.rdp_gateway_instance_type
  
  # Network settings
  subnet_id = element(aws_subnet.vpc_public_subnets.*.id, count.index % 2)
  availability_zone = element(data.aws_availability_zones.available.names, count.index % 2)
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.rdp_gateway_sg.id, aws_security_group.vpc_public_sg.id]
  
  # Security
  key_name = aws_key_pair.instance_key.key_name  
  get_password_data = true  
  source_dest_check = false

  root_block_device {
    volume_size = 30
    delete_on_termination = true
  }

  tags = {
    Name = "rdp_gateway-${count.index}-${random_id.instance.hex}"
  }
}
