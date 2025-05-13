
module "yandex_cloud_network" {
  source = "./modules/tf-yc-network"
  vm_name_net = var.vm_name_net
  vm_name_innet = var.vm_name_innet
  vm_name_subnet = var.vm_name_subnet
}

locals {
  branch_suffix = var.git_branch == "main" ? "prod" : "dev"
  vm_settings = {
    "main" = {
      vm_name = "${var.vm_name}-prod"
      vm_core = 4
      vm_ram = 4
    }
    "develop" = {
      vm_name = "${var.vm_name}-dev"
      vm_core = 2
      vm_ram = 2
    }
  }
}


module "yandex_cloud_vm" {
  source = "./modules/tf-yc-instance"
  vm_boot_size = 40  #объем харда
  vm_image_id = var.vm_image_id # можно задать какой образ системы использовать
  vm_zone = var.zone1 # -var задается сетевая зона
  vm_name = local.vm_settings[var.git_branch].vm_name
  vm_core = local.vm_settings[var.git_branch].vm_core
  vm_ram = local.vm_settings[var.git_branch].vm_ram
  vm_schedule = true
  vm_internal_subnet_id = module.yandex_cloud_network.internal_subnet_id
  vm_subnet_id = module.yandex_cloud_network.internal_subnet_id
  vm_nat_ip_address = module.yandex_cloud_network.static_ip_address # внешний ip заданный через output модуля
  vm_nat = true # пустить в инет 
  ssh_public_key = "qq"
  
}
