output "public_ip" {
  description = "The public IP address of the VM"
  value       = azurerm_public_ip.TP_Public_1.ip_address
}

output "username" {
  description = "The admin username for the VM"
  value       = azurerm_linux_virtual_machine.my_terraform_vm.admin_username
}

output "hostname" {
  description = "The hostname of the VM"
  value       = azurerm_linux_virtual_machine.my_terraform_vm.computer_name
}