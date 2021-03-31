# Output variables
output "aws_account" {
  value = var.cloud_provider
}

output "aws_access_key" {
  value = data.centrifyvault_cloudprovider.aws_account
}

output "aws_region" {
  value = var.aws_region
}

output "vpc_id" {
  value = aws_vpc.vpc_name.id
}

output "connector_ids" {
  value = [aws_instance.centrify_connector.*.id]
}

output "connector_ips" {
  value = [aws_instance.centrify_connector.*.private_ip]
}