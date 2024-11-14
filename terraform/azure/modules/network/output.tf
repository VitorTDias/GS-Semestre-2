
output "subnet_vnet10a" {
    value = "${azurerm_subnet.subnet_vnet10a.id}"
}

output "subnet_vnet10b" {
    value = "${azurerm_subnet.subnet_vnet10b.id}"
}

output "rg_name" {
 value = azurerm_resource_group.rg_name
}

output "location" {
 value = azurerm_resource_group.location
}