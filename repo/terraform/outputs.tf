output "vm_public_ip" {
  description = "Public IP address of the VM"
  value       = module.yandex_cloud_vm.public_address
}

output "vm_internal_ip" {
  description = "Internal IP address of the VM"
  value       = module.yandex_cloud_vm.ip_address
}

output "static_ip_address" {
  description = "Allocated static IP address"
  value       = module.yandex_cloud_network.static_ip_address
  sensitive   = true
}