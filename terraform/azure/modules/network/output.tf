
output "subnet_vnet10a" {
    value = "${azurerm_subnet.subnet_vnet10a.id}"
}

output "subnet_vnet10b" {
    value = "${azurerm_subnet.subnet_vnet10b.id}"
}

output "location" {
 value = azurerm_resource_group.rg.location
}

output "rg_name" {
 value = azurerm_resource_group.rg.name
}

output "vnet10" {
  value       = azurerm_virtual_network.vnet10.id
}

