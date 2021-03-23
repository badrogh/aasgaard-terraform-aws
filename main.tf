### Setup our Centrify provider
#
terraform {
  required_providers {
    centrifyvault = {
      source = "marcozj/centrifyvault"
    }
  }
}

provider "centrifyvault" {
  url = var.tenant_url
  appid = "terraform"
  scope = "terraform"
  username = var.centrify_api_user
  password = var.centrify_api_secret
}

### Setup our AWS provider
#
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.aws_region
}

resource "random_id" "instance" {
  byte_length = 8
}

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
