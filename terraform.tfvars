# These variables can be edited in this file or set as global variables in your Terraform Cloud workspace
# Note that aws_access_key_id and aws_secret_access_key should never be edited in this file but always in Terraform Cloud
aws_access_key_id="${AWS_ACCESS_KEY_ID}"
aws_secret_access_key="${AWS_SECRET_ACCESS_KEY}"

# VPC variables
vpc_region="eu-west-2"
vpc_name="Aasgaard-Demo"
vpc_cidr_block="10.0.0.0/8"
vpc_public_subnet_1_cidr="10.0.0.0/24"
vpc_access_from_ip_range="0.0.0.0/0"
vpc_private_subnet_1_cidr="10.1.0.0/16"