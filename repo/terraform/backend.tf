###Создаём бакет для tfstate
terraform {
  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    region     = "ru-central1" #зона доступности
    key       = "terraform/${terraform.workspace}/state"  # директория в зависимости от воркспейса

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_s3_checksum            = true
    skip_requesting_account_id  = true
    }
}