# Output variables
output "aws_region" {
  value = var.aws_region
}

output "vpc_id" {
  value = aws_vpc.vpc_name.id
}

output "instance_private_key" {
  value = tls_private_key.instance_key_pair.private_key_pem
}

output "instance_ids" {
  value = [aws_instance.centrify_connector.*.id]
}