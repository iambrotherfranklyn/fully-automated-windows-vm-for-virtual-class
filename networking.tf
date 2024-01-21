
resource "azurerm_virtual_network" "students_vnet" {
  name                = "${local.owners}-${var.vnet_name}"
  location            = var.location
  resource_group_name = "${local.owners}-${var.resource_group_name}"
  address_space       = var.vnet_address_space
  dns_servers         = ["10.0.0.4"]
  depends_on          = [azurerm_resource_group.rg]
}

resource "azurerm_subnet" "students_subnet" {
  name                 = var.subnet_name
  resource_group_name  = "${local.owners}-${var.resource_group_name}"
  virtual_network_name = "${local.owners}-${var.vnet_name}"
  address_prefixes     = var.subnet_address_prefixes
  depends_on           = [azurerm_virtual_network.students_vnet]
}

resource "azurerm_network_interface" "students_network_interface" {
  for_each            = toset(var.usernames)
  name                = "nic-for-${each.value}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = "${local.owners}-${var.resource_group_name}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.students_subnet.id
    private_ip_address_allocation = "Static"
    public_ip_address_id          = azurerm_public_ip.students_public_ip[each.key].id
  }
  depends_on = [
  azurerm_subnet.students_subnet]
}

resource "azurerm_public_ip" "students_public_ip" {
  for_each            = toset(var.usernames)
  name                = "public-ip-for-${each.value}"
  resource_group_name = "${local.owners}-${var.resource_group_name}"
  location            = var.location
  allocation_method   = "Static"
  depends_on = [ azurerm_resource_group.rg ]
}

resource "azurerm_network_security_group" "students_subnet_nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = "${local.owners}-${var.resource_group_name}"
  depends_on = [ azurerm_network_interface.students_network_interface ]
}

# Locals Block for Security Rules
locals {
  backend_inbound_ports_map = {
    "100" : "3389", # If the key starts with a number, you must use the colon syntax ":" instead of "="
    #"110" : "5985", #allowed traffic on the WinRM port (default is 5985 for HTTP and 5986 for HTTPS)
    "120" : "80",
    "130" : "5986" #allow traffic on the WinRM port (default is 5985 for HTTP and 5986 for HTTPS)
    "140" : "443"
  }
}
## NSG Inbound Rule for backendTier Subnets
resource "azurerm_network_security_rule" "students_nsg_rule_inbound" {
  for_each                    = local.backend_inbound_ports_map
  name                        = "Rule-Port-for-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${local.owners}-${var.resource_group_name}"
  network_security_group_name = azurerm_network_security_group.students_subnet_nsg.name
  depends_on = [ azurerm_network_security_group.students_subnet_nsg ]
}

# Resource-3: Associate NSG and Subnet
resource "azurerm_subnet_network_security_group_association" "students_subnet_nsg_associate" {
  depends_on                = [azurerm_network_security_rule.students_nsg_rule_inbound]
  subnet_id                 = azurerm_subnet.students_subnet.id
  network_security_group_id = azurerm_network_security_group.students_subnet_nsg.id
  
}
