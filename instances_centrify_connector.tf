resource "aws_instance" "cfy_connector_instances" {
  depends_on = [aws_nat_gateway.nat_gw_private]
  count = 2
  
  # Instance type
  ami = data.aws_ami.windows_ami.id
  instance_type = var.connector_instance_type
  
  # Network settings
  subnet_id = element(local.vpc_private_subnets, count.index % 2)  
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.centrify_connector_sg.id, aws_security_group.vpc_private_sg.id]
  availability_zone = element(data.aws_availability_zones.available.names, count.index % 2)

  # Security
  key_name = aws_key_pair.instance_key.key_name  
  #iam_instance_profile = aws_iam_instance_profile.cfy_machine_iam_instance_profile.name
  get_password_data = true  
  source_dest_check = false

  # Data
  user_data = data.template_file.centrify_connector_user_data_payload.rendered

  root_block_device {
    volume_size           = var.connector_disk_size
    delete_on_termination = true
  }

  tags = {
    Name = "${var.vpc_name}-centrify-connector-${count.index}"
  }
}

data "template_file" "centrify_connector_user_data_payload" {
  template = file(
    "${path.module}/data/Install-CentrifyConnector.ps1.template",
  )

  vars = {
    package_url   = var.package_url
    tenant_url   = var.tenant_url
    reg_code   = var.reg_code
  }
}