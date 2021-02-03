resource "aws_instance" "centrify_connector" {
  depends_on = [aws_nat_gateway.nat_gw_private, aws_subnet.vpc_private_subnets]
  
  # Deploy 1 Centrify Connector per private subnet
  count = length(aws_subnet.vpc_private_subnets.*.id)
  
  # Instance type
  ami = data.aws_ami.windows_ami.id
  instance_type = var.connector_instance_type
  
  # Network settings
  subnet_id = element(aws_subnet.vpc_private_subnets.*.id, count.index % 2)
  availability_zone = element(data.aws_availability_zones.available.names, count.index % 2)
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.centrify_connector_sg.id, aws_security_group.vpc_private_sg.id]
  
  # Security
  key_name = aws_key_pair.instance_key.key_name  
  get_password_data = true  
  source_dest_check = false

  # Data
  user_data = data.template_file.connector_install_script.rendered

  root_block_device {
    volume_size = var.connector_disk_size
    delete_on_termination = true
  }

  tags = {
    Name = "centrify-connector-${random_id.server_name.hex}"
  }
}

data "template_file" "connector_install_script" {
  template = file(
    "${path.module}/data/Install-CentrifyConnector.ps1.template",
  )

  vars = {
    package_url = var.package_url
    tenant_url = var.tenant_url
    reg_code = var.reg_code
  }
}