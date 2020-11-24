# main creds for AWS connection
variable "aws_access_key_id" {
  description = "AWS access key"
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
}

variable "availability_zone" {
  description = "availability zone used for the demo, based on region"
  default = {
    eu-west-2 = "eu-west-2a"
    eu-west-2 = "eu-west-2b"
    eu-west-2 = "eu-west-2c"
  }
}

########################### demo VPC Config ##################################

variable "vpc_name" {
  description = "VPC for Terraform provisioning demo"
}

variable "vpc_region" {
  description = "AWS region"
}

variable "vpc_cidr_block" {
  description = "Uber IP addressing for demo Network"
}

variable "vpc_public_subnet_1_cidr" {
  description = "Public 0.0 CIDR for externally accessible subnet"
}

variable "vpc_access_from_ip_range" {
  description = "Access can be made from the following IPs"
}

variable "vpc_private_subnet_1_cidr" {
  description = "Private CIDR for internally accessible subnet"
}
