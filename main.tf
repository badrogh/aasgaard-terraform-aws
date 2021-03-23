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
