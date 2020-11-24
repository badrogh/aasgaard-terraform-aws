# These variables can be edited in this file or set as global variables in your Terraform Cloud workspace
# Note that aws_access_key_id and aws_secret_access_key should never be edited in this file but always in Terraform Cloud
aws_access_key_id="${AWS_ACCESS_KEY_ID}"
aws_secret_access_key="${AWS_SECRET_ACCESS_KEY}"

# VPC variables
vpc_region="${vpc_region}"
vpc_name="${vpc_name}"
vpc_cidr_block="${vpc_cidr_block}"
vpc_public_subnet_1_cidr="${vpc_public_subnet_1_cidr}"
vpc_access_from_ip_range="${vpc_access_from_ip_range}"
vpc_private_subnet_1_cidr="${vpc_private_subnet_1_cidr}"