output "1. linux_vm_public_name" {
  value = "${module.linuxservers.public_ip_dns_name}"
}

output "2. private_key_pem" {
  value = "${module.tls_private_key.private_key_pem}"
}

output "3. openssh_public_key_file" {
  value = "${local.openssh_key}"
}

output "4. openssh_public_key" {
  value = "${module.tls_private_key.public_key_openssh}"
}

output "5. windows_vm_public_name" {
  value = "${module.windowsserver.public_ip_dns_name}"
}

output "6. windows_vm_username" {
  value = "${local.VarAccID}"
}

output "7. windows_vm_password" {
  value = "${random_string.password.result}"
}
