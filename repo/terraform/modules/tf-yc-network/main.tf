#### создаём внешний статический ip для ВМ ###
resource "yandex_vpc_address" "vm_static_ip" {
  name = var.vm_name_net
  
  external_ipv4_address {
    zone_id = var.network_zone
  }
}
#### Создаем внутреннюю сеть pelmennaya-internal-network ####
resource "yandex_vpc_network" "internal_network" {
  name = var.vm_name_innet
}

#### Создаём внутренную подсеть ####
resource "yandex_vpc_subnet" "internal_subnet" {
  name           = var.vm_name_subnet
  zone           = var.network_zone
  network_id     = yandex_vpc_network.internal_network.id # этот id будет использован для другой VM
  v4_cidr_blocks = ["10.42.27.0/24"] # Внутренний диапазон адресов
}
