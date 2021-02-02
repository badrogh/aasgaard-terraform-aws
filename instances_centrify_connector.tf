resource "aws_instance" "cfy_connector_instances" {
  depends_on = [aws_nat_gateway.nat_gw_private]
  count = 2
  
  # Instance type
  ami = data.aws_ami.windows_ami.id
  instance_type = var.connector_instance_type
  
  # Network settings
  subnet_id = element(local.private_subnets, count.index % 2)  
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.centrify_connector_sg.id, aws_security_group.vpc_private_sg.id]
  availability_zone = element(data.aws_availability_zones.available.names, count.index % 2)

  # Security
  key_name = aws_key_pair.instance_key.key_name  
  #iam_instance_profile = aws_iam_instance_profile.cfy_machine_iam_instance_profile.name
  get_password_data = true  
  source_dest_check = false

  root_block_device {
    volume_size           = var.connector_disk_size
    delete_on_termination = true
  }

  tags = {
    Name = "${var.vpc_name}-centrify-connector-${count.index}"
  }
}

resource "null_resource" "PowerShellScriptRunFirstTimeOnly" {
  provisioner "file" {
    source = "${path.module}/data/Install-CentrifyConnector.ps1"
	destination = "C:\Temp\Centrify\Install-CentrifyConnector.ps1"
  }
  
  provisioner "remote-exec" {
    inline = "C:\\Temp\\Centrify\\Install-CentrifyConnector.ps1 -PackageURL '${var.package_url}' -TenantURL '${var.tenant_url}' -RegCode '${var.reg_code}'"
  }
}