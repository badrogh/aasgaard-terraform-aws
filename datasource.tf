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
data "centrifyvault_cloudprovider" "aws_account" {
  name = var.cloud_provider
  cloud_account_id = var.cloud_provider_id
}

data "centrifyvault_vaultaccount" "aws_access_key" {
  name = "Terraform"
  access_key_id = var.aws_access_key
  cloudprovider_id = data.centrifyvault_cloudprovider.aws_account.id
  checkout = true
}

data "centrifyvault_role" "system_admin" {
  name = "System Administrator"
}
