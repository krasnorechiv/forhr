module "yandex_cloud_network" {
  source = "./modules/tf-yc-network"
}

module "yandex_cloud_vm" {
  source = "./modules/tf-yc-instance"
  vm_boot-size = 40
  vm_image-id = var.vm_image-id
  vm_zone = var.zone1
  vm_name = var.vm_name
  vm_core = "2"
  vm_ram = "2"
  vm_schedule = true
  vm_subnet-id = module.yandex_cloud_network.yandex_vpc_subnets[var.zone1].subnet_id
  vm_nat = true 
}
