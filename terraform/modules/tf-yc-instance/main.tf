data "yandex_compute_image" "my_image" {
    family = var.vm_image-id
}
resource "yandex_compute_instance" "vm-1" {
    name = var.vm_name
    zone = var.vm_zone
    platform_id = var.vm_platf-id
    

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
            size = var.vm_boot-size
        }
    }
    #Политика планирования
    scheduling_policy {
       preemptible = var.vm_schedule
    }
    # Сетевой интерфейс:
    # нужно указать идентификатор подсети, к которой будет подключена ВМ
    network_interface {
        subnet_id = var.vm_subnet-id
        nat       = var.vm_nat   #почему-то не работает (permisson denied)
#        nat_ip_address = yandex_computer_instance.addr.external_ipv4_address[0].address
    }

    # Метаданные машины:
    # здесь можно указать скрипт, который запустится при создании ВМ
    # или список SSH-ключей для доступа на ВМ
    metadata = {
        user-data = "${file("./modules/tf-yc-instance/cloud-init")}"
    }
}
