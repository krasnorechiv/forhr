
###Какой образ использовать####
data "yandex_compute_image" "my_image" {
    family = var.vm_image_id
}
resource "null_resource" "ssh_key_trigger" {
  triggers = {
    ssh_key = var.ssh_public_key
  }
}
 
resource "yandex_compute_instance" "vm-1" {
    name = var.vm_name
    zone = var.vm_zone
    platform_id = var.vm_platf_id
    allow_stopping_for_update = true
    labels      = var.tags
    

    # Конфигурация ресурсов:
    # количество процессоров и оперативной памяти
    resources {
        cores  = var.vm_core
        memory = var.vm_ram
    }

    # Загрузочный диск:
    # здесь указывается образ операционной системы
    # для новой виртуальной машины
    boot_disk {
        initialize_params {
            image_id = "${data.yandex_compute_image.my_image.id}"
            size = var.vm_boot_size
        }
    }
    #Политика планирования
    scheduling_policy {
       preemptible = var.vm_schedule
    }
    # Сетевой интерфейс:
    # нужно указать идентификатор подсети, к которой будет подключена ВМ
    network_interface {
        subnet_id = var.vm_subnet_id
        nat       = var.vm_nat   #выпускаем в инет
        nat_ip_address = var.vm_nat_ip_address # назначем статику
    }

    # Метаданные машины:
    # здесь можно указать скрипт, который запустится при создании ВМ
    # или список SSH-ключей для доступа на ВМ
    metadata = {
        user-data = "${file("./modules/tf-yc-instance/cloud-init")}"
      }
    
  lifecycle {
    create_before_destroy = true  # сначала создаёт новый, потом удаляет старый
  }

}
