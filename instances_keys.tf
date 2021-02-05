### Instances Key pairs
# Create a keypair for access to any machines we create (also necessary to get windows password)
resource "tls_private_key" "instance_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "instance_key" {
  key_name   = "instance-key-${random_id.instance.hex}"
  public_key = tls_private_key.instance_key_pair.public_key_openssh
}

# Note that writing private key to ouutput folders only work with TerraformCLI executed locally
# When using Terraform Cloud, private key is instead output in the console after Terraform apply
resource "local_file" "instance_private_key" {
  content  = tls_private_key.instance_key_pair.private_key_pem
  filename = "${path.module}/output/instance_key.priv"
}