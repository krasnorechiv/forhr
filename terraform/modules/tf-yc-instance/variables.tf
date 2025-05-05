#####GEO_ZONE#####
variable "vm_zone" {
  description = "Yandex.Cloud network availability zones"
  type        = string
  nullable    = false
 
}

#####PLATFORM#####
variable "vm_platf-id" {
  description = "What type of hardware should be used"
  type        = string
  default     = "standard-v1"
  sensitive   = false
  nullable    = false
}

######IMAGE######
variable "vm_image-id" {
  description = "What image of operating system should be used"
  type        = string
#  default     = "fd80qm01ah03dkqb14lc"
  validation {
    condition     = contains(toset(["ubuntu-2004-lts-vgpu", "centos-7-gpu", "ubuntu-2204-lts"]), var.vm_image-id)
    error_message = "Select image from the list: ubuntu-2004-lts-vgpu, centos-7-gpu, ubuntu-2204-lts."
    }
  sensitive   = false
  nullable    = false
}
variable "vm_boot-size" {
  description = "A count of GB disk size"
  type        = number
  default     = 20
  nullable    = false
  validation {
     condition     = var.vm_boot-size >= 30 && var.vm_boot-size <= 40 && floor(var.vm_boot-size) == var.vm_boot-size
     error_message = "From 30G to 40G will be fine"
     }
}
######
variable "vm_name" {
  description = "Name of VM"
  type        = string
  default     = "chapter7-lesson2-std-ext-013-12"
}
######
variable "vm_core" {
  description = "Count of CPU Cores"
  type        = number
  default     = 2
  validation {
     condition     = var.vm_core >= 1 && var.vm_core <= 2 && floor(var.vm_core) == var.vm_core
     error_message = "From 1C to 2C will be fine"
     }
}

######
variable "vm_ram" {
  description = "Count of GB of RAM"
  type        = number
  default     = 2
  validation {
     condition     = var.vm_ram >= 1 && var.vm_ram <= 2 && floor(var.vm_ram) == var.vm_ram
     error_message = "From 1G to 2G will be fine"
      }
}

######
variable "vm_schedule" {
  description = "Scheduling Policy"
  type        = bool
  default     = true
}
######
variable "vm_subnet-id" {
  description = "subnet id of VM"
  type        = string
}
variable "vm_nat" {
  description = "public ip address: true or false"
  type        = bool
}