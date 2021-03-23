### Instances Key pairs
# Create a keypair for access to any machines we create (also necessary to get windows password)
resource "tls_private_key" "instance_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "instance_key" {
  key_name   = "instance-key-${var.vpc_name}"
  public_key = tls_private_key.instance_key_pair.public_key_openssh
}

# Private key is vaulted in Centrify tenant for accessibility to systems
resource "centrifyvault_sshkey" "instance_private_key" {
  name = "instance-key-${var.vpc_name}"
  description = "AWS SSH Key pair"
  private_key  = tls_private_key.instance_key_pair.private_key_pem
  passphrase = ""
  
  permission {
    principal_id = data.centrifyvault_role.system_admin.id
    principal_name = data.centrifyvault_role.system_admin.name
    principal_type = "Role"
    rights = ["Grant","View","Edit","Delete","Retrieve"]
  }
}