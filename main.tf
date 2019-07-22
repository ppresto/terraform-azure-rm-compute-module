terraform {
  required_version = ">= 0.11.6"
}

/*
Generated random admin account
*/
resource "random_string" "AccID" {
  length      = 5
  special     = false
  number      = true
  min_numeric = 5
}

resource "random_string" "password" {
  length           = 16
  special          = true
  override_special = "/@\" "
}

#Create local administrator Account ID - Example ID: Hashi23756
locals {
  VarAccID    = "Hashi-${random_string.AccID.result}"
  openssh_key = "./${replace(module.tls_private_key.private_key_filename,"/^ssh-keypair-(.*).key.pem$/", "ssh-rsa-$1")}"
}

module "tls_private_key" {
  source = "github.com/hashicorp-modules/tls-private-key"

  create   = "true"
  name     = "ssh-keypair"
  rsa_bits = "2048"
}

resource "null_resource" "download_openssh_key" {
  #count = "${var.create ? 1 : 0}"

  provisioner "local-exec" {
    command = "echo '${module.tls_private_key.public_key_openssh}' > ${local.openssh_key} && chmod 0600 ${local.openssh_key}"
  }
}

module "linuxservers" {
  source              = "Azure/compute/azurerm"
  nb_instances        = "${var.count_linux}"
  location            = "${var.location}"
  vm_os_simple        = "UbuntuServer"
  public_ip_dns       = ["${var.dns_prefix}-lin"]           // change to a unique name per datacenter region
  ssh_key             = "${local.openssh_key}"
  vnet_subnet_id      = "${module.network.vnet_subnets[0]}"
  resource_group_name = "${var.dns_prefix}-rg"

  tags = {
    environment = "dev"
    ttl         = "24"
  }
}

module "windowsserver" {
  source              = "Azure/compute/azurerm"
  version             = "1.2.1"
  nb_instances        = "${var.count_windows}"
  location            = "${var.location}"
  resource_group_name = "${var.dns_prefix}-rg"
  vm_hostname         = "${var.dns_prefix}-win"
  admin_username      = "${local.VarAccID}"
  admin_password      = "${random_string.password.result}"
  vm_os_simple        = "WindowsServer"
  is_windows_image    = "true"
  public_ip_dns       = ["${var.dns_prefix}-win"]
  vnet_subnet_id      = "${module.network.vnet_subnets[0]}"
}

module "network" {
  source              = "Azure/network/azurerm"
  version             = "1.1.1"
  location            = "${var.location}"
  resource_group_name = "${var.dns_prefix}-rg"
  allow_ssh_traffic   = "true"
  allow_rdp_traffic   = "true"
}
