
####возращаемое значение для переменной   vm_nat_ip_address ####
output "static_ip_address" {
  value = yandex_vpc_address.vm_static_ip.external_ipv4_address[0].address
}

####Возвращаемое значение для переменной vm_internal_subnet_id
output "internal_subnet_id" {
  value = yandex_vpc_subnet.internal_subnet.id
}
output "internal_network_id" {
  value = yandex_vpc_network.internal_network.id
}
