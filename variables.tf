# Credentials for AWS connection
variable "AWS_ACCESS_KEY_ID" {
    description = "AWS access key"
}

variable "AWS_SECRET_ACCESS_KEY" {
    description = "AWS secret access key"
}

# AWS VPC configuration
variable "vpc_name" {
    description = "Terraformed AWS VPC"
    default = "demo-vpc"
}

variable "vpc_region" {
    description = "AWS VPC region"
    default = "us-east-1"
}

variable "vpc_cidr_block" {
    description = "AWS VPC CIDR block"
    default = "10.0.0.0/16"
}

variable "vpc_access_from_ip_range" {
    description = "VPC access can be made from these IPs"
    default = "0.0.0.0/0"
}

variable "vpc_public_subnet_1_cidr" {
    description = "Public Subnet CIDR for externally accessible resources"
    default = "10.0.0.0/24"
}

variable "vpc_private_subnet_1_cidr" {
    description = "Private Subnet CIDR for internally accessible resources"
    default = "10.0.1.0/24"
}
