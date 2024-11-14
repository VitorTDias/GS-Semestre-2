resource "azurerm_availability_set" "as_public" {
    name                = "as-public"
    location            = "${var.location}"
    resource_group_name = "${var.rg_name}"
}

resource "azurerm_public_ip" "publiciplb" {
  name                = "PublicIPForLB"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
}

resource "azurerm_lb" "lbvnet10" {
  name                = "TestLoadBalancer"
  location            = var.location
  resource_group_name = var.rg_name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.publiciplb.id
  }
}

//vm 1
resource "azurerm_public_ip" "vm01_pip_public" {
    name                = "vm01-pip-public"
    location            = "${var.location}"
    resource_group_name = "${var.rg_name}"
    allocation_method   = "Static"
    domain_name_label   = "vm01-pip-public"
}

resource "azurerm_network_interface" "vm01_nic_public" {
    name                = "vm01-nic-public"
    location            = "${var.location}"
    resource_group_name = "${var.rg_name}"
    ip_configuration {
        name                          = "vm01-ipconfig-public"
        subnet_id                     = "${var.subnet_vnet10a}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.vm01_pip_public.id
    }
}


resource "azurerm_virtual_machine" "vm01_public" {
    name                             = "vm01-public"
    location                         = "${var.location}"
    resource_group_name              = "${var.rg_name}"
    network_interface_ids            = [azurerm_network_interface.vm01_nic_public.id]
    availability_set_id              = azurerm_availability_set.as_public.id
    vm_size                          = "Standard_D2s_v3"
    delete_os_disk_on_termination    = true
    delete_data_disks_on_termination = true
    storage_image_reference {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
    }
    storage_os_disk {
        name              = "vm01-os-disk-public"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    os_profile {
        computer_name  = "vm01-public"
        admin_username = "azureuser"
        admin_password = "Password1234!"
        custom_data    = "${base64encode(data.template_file.cloud_init.rendered)}"
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
}


//// vm 2


resource "azurerm_public_ip" "vm02_pip_public" {
    name                = "vm02-pip-public"
    location            = "${var.location}"
    resource_group_name = "${var.rg_name}"
    allocation_method   = "Static"
    domain_name_label   = "vm02-pip-public"
}

resource "azurerm_network_interface" "vm02_nic_public" {
     name                             = "vm02-public"
    location                         = "${var.location}"
    resource_group_name              = "${var.rg_name}"
    network_interface_ids            = [azurerm_network_interface.vm02_nic_public.id]
    availability_set_id              = azurerm_availability_set.as_public.id
    vm_size                          = "Standard_D2s_v3"
    delete_os_disk_on_termination    = true
    delete_data_disks_on_termination = true
    storage_image_reference {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
    }
}

resource "azurerm_virtual_machine" "vm02_public" {
    name                          = "vm02-public"
    location            = "${var.location}"
    resource_group_name = "${var.rg_name}"
    network_interface_ids         = [azurerm_network_interface.vm02_nic_public.id]
    vm_size                       = "Standard_D2s_v3"
    delete_os_disk_on_termination = true
    storage_image_reference {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
    }
    storage_os_disk {
        name              = "vm02-os-disk-public"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    os_profile {
        computer_name  = "vm02-public"
        admin_username = "azureuser"
        admin_password = "Password1234!"
        custom_data    = <<-EOF
         #!/bin/bash
            sudo apt-get update
            sudo apt-get install -y python3 python3-pip
            pip3 install flask
             cat << 'EOF2' > /home/ubuntu/app.py
            from flask import Flask
             app = Flask(__name__)
             @app.route('/')
             def home():
            return "Hello, Azure from Flask!"
             if __name__ == '__main__':
          app.run(host='0.0.0.0', port=5000)
          EOF2
          nohup python3 /home/ubuntu/app.py &
        EOF
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
}


///// security group

resource "azurerm_network_security_group" "nsgvnet10" {
    name                = "nsgvnet10"
    location            = "${var.location}"
    resource_group_name = "${var.rg_name}"
    security_rule {
        name                       = "Inbound-Internet-HTTP"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "Inbound-Internet-SSH"
        priority                   = 1011
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
    }
}

resource "azurerm_subnet_network_security_group_association" "nsgsnvnet10puba" {
    subnet_id                 = "${var.subnet_vnet10a}"
    network_security_group_id = azurerm_network_security_group.nsgvnet10.id
}

resource "azurerm_subnet_network_security_group_association" "nsgsnvnet10pubb" {
    subnet_id                 =  "${var.subnet_vnet10b}"
    network_security_group_id = azurerm_network_security_group.nsgvnet10.id
}

