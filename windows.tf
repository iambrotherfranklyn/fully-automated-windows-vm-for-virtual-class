
resource "azurerm_windows_virtual_machine" "lab_windows_vm" {
  for_each            = toset(var.usernames)
  name                = "lab-vm-for-${each.key}"
  computer_name       = "vm-${each.key}"
  resource_group_name = "${local.owners}-${var.resource_group_name}"
  location            = azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.vm_admin_username
  admin_password      = var.vm_admin_password

  network_interface_ids = [azurerm_network_interface.students_network_interface[each.key].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }



  #priority        = "Spot"
  #eviction_policy = "Deallocate"
  #max_bid_price   = -1
  #depends_on      =  [azurerm_network_interface.network_interface]


/*
  provisioner "file" {
    content     = file("${path.module}/script.ps1")
    destination = "C:\\script.ps1"
  }

  provisioner "remote-exec" {
    script = "C:\\script.ps1"
  }

  connection {
    type     = "winrm"
    host     = self.private_ip_address
    user     = var.vm_admin_username
    password = var.vm_admin_password
  }
*/
depends_on = [azurerm_subnet.students_subnet]
}


