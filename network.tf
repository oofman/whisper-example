resource "azurerm_virtual_network" "whisper-network" {
  name                = "${var.prefix}-network"
  location            = var.location
  resource_group_name = azurerm_resource_group.whisper-rg.name
  address_space       = ["10.0.0.0/16"] # 65534 ips (-5 for admin)
  
  tags = {
    env     = "whisper-example"
  }
}

resource "azurerm_subnet" "whisper-network-internal" {
  name                 = "${var.prefix}-internal"
  resource_group_name  = azurerm_resource_group.whisper-rg.name
  virtual_network_name = azurerm_virtual_network.whisper-network.name
  address_prefixes     = ["10.0.0.0/24"] # 256 ips (-5 for admin)

  # tags = {
  #   env     = "whisper-example"
  # }
}

resource "azurerm_network_security_group" "allow-ssh" {
  name                = "${var.prefix}-allow-ssh"
  location            = var.location
  resource_group_name = azurerm_resource_group.whisper-rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.ssh-source-address
    destination_address_prefix = "*"
  }

  tags      = {
    env     = "whisper-example"
  }
}