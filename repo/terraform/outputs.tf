#output "yandex_vpc_subnets" {
#  value = module.yandex_cloud_network.yandex_vpc_subnets
#}
output "ip_address" {
  value = module.yandex_cloud_vm.ip_address
}
output "public_address" {
  value = module.yandex_cloud_vm.public_address
}
#output "yandex_vps_networks" {
#  value = module.yandex_cloud_network.yandex_vpc_networks
#}
