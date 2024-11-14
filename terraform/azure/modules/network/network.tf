resource "azurerm_resource_group" "rg" {
    name     = "${var.rg_name}"
    location = "${var.location}"
}

resource "azurerm_virtual_network" "vnet10" {
    name                = "vnet10"
    location            = "${var.location}"
    resource_group_name = "${var.rg_name}"
    address_space       = ["10.0.0.0/16"]
}


resource "azurerm_subnet" "subnet_vnet10a" {
    name                 = "subnet_vnet10a"
    resource_group_name  = "${var.rg_name}"
    virtual_network_name = azurerm_virtual_network.vnet10.name
    address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet_vnet10b" {
    name                 = "subnet_vnet10b"
    resource_group_name  = "${var.rg_name}"
    virtual_network_name = azurerm_virtual_network.vnet10.name
    address_prefixes     = ["10.0.2.0/24"]
}

