variable "cloud_id" {
  description = "Cloud id for Yandex"
  type        = string
  sensitive = true
  nullable = false
}

variable "folder_id" {
  description = "Folder id for Yandex"
  type        = string
  sensitive = true
  nullable = false
}

variable "token1" {
  description = "Yandex token"
  type        = string
  sensitive = true
  nullable = false
}

variable "zone1" {
  description = "zone"
  type        = string
#  default = "ru-central1-b"
  nullable = false
  validation {
   condition     = contains(toset(["ru-central1-a", "ru-central1-b", "ru-central1-c"]), var.zone1)
    error_message = "Select availability zone from the list: ru-central1-a, ru-central1-b, ru-central1-c."
  }
}

variable "vm_image_id" {
  description = "image of OS for VM"
  type        = string
  sensitive = true
  nullable = false
}

variable "vm_name" {
  description = "name of VM"
  type        = string
  sensitive = true
  nullable = false
}
