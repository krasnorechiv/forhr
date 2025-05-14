#####Гео-зона#####
variable "vm_zone" {
  description = "Yandex.Cloud network availability zones"
  type        = string
  nullable    = false
 
}

#####Платформа-PC#####
variable "vm_platf_id" {
  description = "What type of hardware should be used"
  type        = string
  default     = "standard-v3"
  sensitive   = false
  nullable    = false
}

######Образ######
variable "vm_image_id" {
  description = "What image of operating system should be used"
  type        = string
#  default     = "fd80qm01ah03dkqb14lc"
  validation {
    condition     = contains(toset(["ubuntu-2004-lts-vgpu", "centos-7-gpu", "ubuntu-2204-lts"]), var.vm_image_id)
    error_message = "Select image from the list: ubuntu-2004-lts-vgpu, centos-7-gpu, ubuntu-2204-lts."
    }
  sensitive   = false
  nullable    = false
}

######Размер образа######
variable "vm_boot_size" {
  description = "A count of GB disk size"
  type        = number
  default     = 20
  nullable    = false
  validation {
     condition     = var.vm_boot_size >= 30 && var.vm_boot_size <= 40 && floor(var.vm_boot_size) == var.vm_boot_size
     error_message = "From 30G to 40G will be fine"
     }
}
######Имя инстанса######
variable "vm_name" {
  description = "Name of VM"
  type        = string
  default     = "chapter7-lesson2-std-ext-013-12"
}
######Кол-во ядер######
variable "vm_core" {
  description = "Count of CPU Cores"
  type        = number
  default     = 2
  validation {
     condition     = var.vm_core >= 1 && var.vm_core <= 6 && floor(var.vm_core) == var.vm_core
     error_message = "From 1C to 6C will be fine"
     }
}

######Кол-во памяти######
variable "vm_ram" {
  description = "Count of GB of RAM"
  type        = number
  default     = 2
  validation {
     condition     = var.vm_ram >= 1 && var.vm_ram <= 6 && floor(var.vm_ram) == var.vm_ram
     error_message = "From 1G to 6G will be fine"
      }
}

######Прерываемая######
variable "vm_schedule" {
  description = "Scheduling Policy"
  type        = bool
  default     = true
}
######Прерываемая######
variable "vm_subnet_id" {
  description = "subnet id of VM"
  type        = string
}
######Публичный######
variable "vm_nat" {
  description = "public ip address: true or false"
  type        = bool
}
######Статика######
variable "vm_nat_ip_address" {
  description = "subnet id of VM"
  type        = string
}
######Внутренний ID для подсети######
variable "vm_internal_subnet_id" {
  description = "ID внутренней подсети для общения между ВМ"
  type        = string
}
######Теги для ВМ######
variable "tags" {
  description = "Теги"
  type        = map(string)
  default     = {}
}