### Input variables
#

### Credentials for AWS connection
# Note that both aws_access_key and aws_secret_key should always be variables set in your Terraform 
# workspaces instead of using variables.tf file when using Terraform Cloud.
# The aws_secret_access_key should always be set as Sensitive (write only)

variable "aws_access_key" {
    description = "AWS access key"
}

variable "aws_secret_key" {
    description = "AWS secret access key"
}

### AWS VPC configuration
# You can edit default AWS region here 
# You can edit or add CIDR blocks for both Public and Private subnets
variable "vpc_name" {
    description = "Demo of a Terraform managed VPC"
    default = "vpc-terraform-demo"
}

variable "aws_region" {
    description = "AWS VPC region"
    default = "us-east-1"
}

variable "vpc_cidr_block" {
    description = "AWS VPC CIDR block"
    default = "10.10.0.0/16"
}

variable "vpc_public_subnet_cidrs" {
    description = "Public Subnets CIDR for externally accessible resources"
    default = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "vpc_private_subnet_cidrs" {
    description = "Private Subnets CIDR for internally accessible resources"
    default = ["10.10.10.0/24", "10.10.20.0/24"]
}

### Centrify variable
# Default values to use for Centrify Connector installation and enrolment
# Values specific to your environment should be set in your Terraform workspace instead of editing this file.
# The reg_code variable should always be set as Sensitive (write only)
# Centrify Connector servers uses t2.micro instance type by default, this is only suitable for this demo,
# for eval or production deployment you should edit instance type to suite your needs (t2.large is minimum recommended)
#
variable "centrify_api_user" {
    description = "Centrify Service User username for OAuth2 token authentication"
}

variable "centrify_api_secret" {
    description = "Centrify Service User secret for OAuth2 token authentication"
}

variable "package_url" {
    description = "Centrify Connector Installer package download URL"
    default = "https://edge.centrify.com/products/cloud-service/ProxyDownload/Centrify-Connector-Installer.zip"
}

variable "tenant_url" {
    description = "Centrify Platform tenant URL to use for enrolment"
}

variable "reg_code" {
    description = "Registration code for Centrify Connector enrolment"
}

variable "connector_instance_type" {
  description = "Instance type for Centrify Connector server"
  default = "t2.medium"
}

variable "connector_disk_size" {
  description = "Volume Size for Centrify Connector Machine EBS volume (default = 100)"
  default     = "100"
}
