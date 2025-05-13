module "yandex_cloud_network" {
  source = "./modules/tf-yc-network"
  
  vm_name_net    = local.network_names.net
  vm_name_innet  = local.network_names.innet
  vm_name_subnet = local.network_names.subnet
  network_zone   = var.zone1
}

module "yandex_cloud_vm" {
  source = "./modules/tf-yc-instance"
  
  vm_boot_size          = 40
  vm_image_id           = var.vm_image_id
  vm_zone               = var.zone1
  vm_name               = local.safe_vm_name
  vm_core               = local.vm_settings[var.git_branch].vm_core
  vm_ram                = local.vm_settings[var.git_branch].vm_ram
  vm_schedule           = true
  vm_internal_subnet_id = module.yandex_cloud_network.internal_subnet_id
  vm_subnet_id          = module.yandex_cloud_network.internal_subnet_id
  vm_nat_ip_address     = module.yandex_cloud_network.static_ip_address
  vm_nat                = true
  
  tags = local.common_tags
}