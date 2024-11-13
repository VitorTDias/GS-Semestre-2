resource "azurerm_public_ip" "publiciplb" {
  name                = "PublicIPForLB"
  location            = var.rgname
  resource_group_name = var.rglocation
  allocation_method   = "Static"
}

resource "azurerm_lb" "lbvnet10" {
  name                = "TestLoadBalancer"
  location            = var.rgname
  resource_group_name = var.rglocation

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.publiciplb.id
  }
}