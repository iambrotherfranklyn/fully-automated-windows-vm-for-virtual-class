/*
resource "tls_private_key" "linuxkey" {
  for_each  = toset(var.usernames)
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "linuxpemkey" {
  for_each = toset(var.usernames)
  filename = "${each.key}-linuxkey.pem"
  content  = tls_private_key.linuxkey[each.key].private_key_pem
}

# Assuming you have a network interface resource defined similar to this:
resource "azurerm_network_interface" "vm_nic" {
  for_each            = toset(var.usernames)
  name                = "nic-${each.value}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = "${local.owners}-${var.resource_group_name}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.lab_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "lab_linux_vm" {
  for_each              = toset(var.usernames)
  name                  = "lab-linux-vm-${each.key}"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = var.vm_size
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.network_interface[each.key].id]

  admin_ssh_key {
    username   = "linuxusr"
    public_key = tls_private_key.linuxkey[each.key].public_key_openssh
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  priority        = "Spot"
  eviction_policy = "Deallocate"
  max_bid_price   = -1
  depends_on = [
    azurerm_network_interface.vm_nic,
    tls_private_key.linuxkey
  ]
}
*/