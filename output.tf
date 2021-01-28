# Output variables
output "aws_region" {
  value = var.aws_region
}

output "vpc_id" {
  value = aws_vpc.vpc_name.id
}

output "vpc_public_subnets_ids" {
  value = [aws_subnet.vpc_public_subnets.*.id]
}

output "vpc_private_subnets_ids" {
  value = [aws_subnet.vpc_public_subnets.*.id]
}

output "vpc_centrify_connector_sg_id" {
  value = aws_security_group.centrify_connector_sg.id
}

output "vpc_public_sg_id" {
  value = aws_security_group.vpc_public_sg.id
}

output "vpc_private_sg_id" {
  value = aws_security_group.vpc_private_sg.id
}