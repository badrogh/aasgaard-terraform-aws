### Instances Key pairs
# Create a keypair for access to any machines we create (also necessary to get windows password)
resource "tls_private_key" "instance_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "instance_key" {
  key_name   = "${var.vpc_name}-instance-key"
  public_key = tls_private_key.instance_key_pair.public_key_openssh
}

resource "local_file" "instance_private_key" {
  content  = tls_private_key.instance_key_pair.private_key_pem
  filename = "${path.module}/output/instance_key.priv"
}