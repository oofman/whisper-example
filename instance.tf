resource "azurerm_virtual_machine" "whisper-instance" {
  name                  = "${var.prefix}-vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.whisper-rg.name
  network_interface_ids = [azurerm_network_interface.whisper-instance.id]
  vm_size               = "Standard_B1ls" #cheapest under free tier

  # this is a demo instance, so we can delete all data on termination
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "whisper-instance"
    admin_username = "whisper"
    #admin_password = "..."
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("mykey.pub")
      path     = "/home/whisper/.ssh/authorized_keys"
    }
  }

  tags = {
    env = "whisper-example"
  }
}

resource "azurerm_network_interface" "whisper-instance" {
  name                = "${var.prefix}-instance1"
  location            = var.location
  resource_group_name = azurerm_resource_group.whisper-rg.name

  ip_configuration {
    name                          = "instance1"
    subnet_id                     = azurerm_subnet.whisper-network-internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.whisper-instance.id
  }

  tags = {
    env = "whisper-example"
  }
}

resource "azurerm_network_interface_security_group_association" "allow-ssh" {
  network_interface_id      = azurerm_network_interface.whisper-instance.id
  network_security_group_id = azurerm_network_security_group.allow-ssh.id

  # tags = {
  #   env = "whisper-example"
  # }
}

resource "azurerm_public_ip" "whisper-instance" {
  name                = "instance1-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.whisper-rg.name
  allocation_method   = "Dynamic"

  tags = {
    env = "whisper-example"
  }
}