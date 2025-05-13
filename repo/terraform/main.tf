
module "yandex_cloud_network" {
  source = "./modules/tf-yc-network"
}


module "yandex_cloud_vm" {
  source = "./modules/tf-yc-instance"
  vm_boot_size = 40  #объем харда
  vm_image_id = var.vm_image_id # можно задать какой образ системы использовать
  vm_zone = var.zone1 # -var задается сетевая зона
  vm_name = var.vm_name # -var имя ВМ1
  vm_core = "2" 
  vm_ram = "2"
  vm_schedule = true
  vm_internal_subnet_id = module.yandex_cloud_network.internal_subnet_id
  vm_subnet_id = module.yandex_cloud_network.internal_subnet_id
  vm_nat_ip_address = module.yandex_cloud_network.static_ip_address # внешний ip заданный через output модуля
  vm_nat = true # пустить в инет 
  ssh_public_key = "qq"
  
}
