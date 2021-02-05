# Output variables
output "aws_region" {
  value = var.aws_region
}

output "vpc_id" {
  value = aws_vpc.vpc_name.id
}

# Section ONLY needed for using Terraform Cloud, comment out if using TerraformCLI
# Running TerraformCLI you don't need to output private key on console which is instead wrote into output folder
output "instance_private_key" {
  value = tls_private_key.instance_key_pair.private_key_pem
}

output "instance_ids" {
  value = [aws_instance.centrify_connector.*.id]
}