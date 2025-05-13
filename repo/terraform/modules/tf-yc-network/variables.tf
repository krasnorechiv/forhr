variable "network_zone" {
  description = "Yandex.Cloud network availability zones"
  type        = string
  default     = "ru-central1-a"
 validation {
    condition     = contains(toset(["ru-central1-a", "ru-central1-b", "ru-central1-c"]), var.network_zone)
    error_message = "Select availability zone from the list: ru-central1-a, ru-central1-b, ru-central1-c."
  }
  sensitive = false
  nullable = false
}
variable "vm_name_net" {
  description = "Name for the static IP address"
  type        = string
}

variable "vm_name_innet" {
  description = "Name for the internal network"
  type        = string
}

variable "vm_name_subnet" {
  description = "Name for the internal subnet"
  type        = string
}
