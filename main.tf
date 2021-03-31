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
  access_key = data.centrifyvault_vaultaccount.aws_access_key.id
  secret_key = data.centrifyvault_vaultaccount.aws_access_key.secret_access_key
  region = var.aws_region
}
