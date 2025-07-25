output "public_ssh_key" {
  # Only output a generated ssh public key
  value = var.public_ssh_key != "" ? "" : tls_private_key.ssh.public_key_openssh
}

output "private_ssh_key" {
  # Only output a generated ssh private key
  value = var.public_ssh_key != "" ? "" : tls_private_key.ssh.private_key_pem
}