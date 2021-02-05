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

  root_block_device {
    volume_size = var.connector_disk_size
    delete_on_termination = true
  }

  tags = {
    Name = "centrify-connector-${count.index}-${random_id.instance.hex}"
  }
}

resource "null_resource" "PowerShellScriptRunFirstTimeOnly" {
  # Copy install script
  provisioner "file" {
    source = "${path.module}/data/Install-CentrifyConnector.ps1"
    destination = "C:/Windows/Temp/Install-CentrifyConnector.ps1"
  }
  
  # Execute install script
  provisioner "local-exec" {
    command = "PowerShell.exe -ExecutionPolicy ByPass -File C:/Windows/Temp/Install-CentrifyConnector.ps1 -PackageURL ${var.package_url} -TenantURL ${var.tenant_url} -RegCode ${var.reg_code}"
    interpreter = ["PowerShell", "-Command"]
  }
}