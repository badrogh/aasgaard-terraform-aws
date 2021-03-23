### AMI selections
# Use this section to list out the AMI to use for instances creation
data "aws_ami" "windows_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*Windows_Server-2019-English-Full-Base*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

### Centrify Provider
data "centrifyvault_role" "system_admin" {
    name = "System Administrator"
}
