resource "azurerm_resource_group" "Terraform_Practices_RG" {
  name     = "Terraform_Practices_RG"
  location = var.location
  tags = {
    environment = var.tags
  }
}

resource "azurerm_virtual_network" "practices" {
  name                = "practices_network"
  resource_group_name = azurerm_resource_group.Terraform_Practices_RG.name
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.Terraform_Practices_RG.location

  tags = {
    environment = var.tags
  }
}

resource "azurerm_subnet" "TP_subnet" {
  name                 = "subnet_A"
  resource_group_name  = azurerm_resource_group.Terraform_Practices_RG.name
  virtual_network_name = azurerm_virtual_network.practices.name
  address_prefixes     = ["10.10.1.0/24"]

}

resource "azurerm_network_security_group" "TP_SG" {
  name                = "TP-SG"
  location            = azurerm_resource_group.Terraform_Practices_RG.location
  resource_group_name = azurerm_resource_group.Terraform_Practices_RG.name

  tags = {
    environment = var.tags
  }
}

resource "azurerm_network_security_rule" "example" {
  name                        = "SSH"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.Terraform_Practices_RG.name
  network_security_group_name = azurerm_network_security_group.TP_SG.name
}

resource "azurerm_public_ip" "TP_Public_1" {
  name                = "${var.vm_name}_Public_1"
  resource_group_name = azurerm_resource_group.Terraform_Practices_RG.name
  location            = azurerm_resource_group.Terraform_Practices_RG.location
  allocation_method   = "Dynamic"

  tags = {
    environment = var.tags
  }
}

resource "azurerm_network_interface" "TP-NIC" {
  name                = "Tp-NIC"
  location            = azurerm_resource_group.Terraform_Practices_RG.location
  resource_group_name = azurerm_resource_group.Terraform_Practices_RG.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.TP_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.TP_Public_1.id
  }

  tags = {
    environment = var.tags
  }
}

resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                            = var.vm_name
  location                        = azurerm_resource_group.Terraform_Practices_RG.location
  resource_group_name             = azurerm_resource_group.Terraform_Practices_RG.name
  network_interface_ids           = [azurerm_network_interface.TP-NIC.id]
  size                            = "Standard_B1s"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.os_version
  }

  os_disk {
    name                 = "${var.vm_name}-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  tags = {
    environment = var.tags
  }
}