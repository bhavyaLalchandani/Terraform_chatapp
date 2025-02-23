# To create a key pair
resource "tls_private_key" "rsa" {
        algorithm = "RSA"
        rsa_bits  = 4096
}
 
# Define the key pair resource
resource "aws_key_pair" "chatapp_key" {
        key_name   = "chatapp-keypair-001"
        public_key = tls_private_key.rsa.public_key_openssh
}
 
# Define the local file resource and Store the Private key in local
resource "local_file" "chatapp_key_local" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "/home/ubuntu/terraform-config/chatapp_keypair_001.pem"
}
