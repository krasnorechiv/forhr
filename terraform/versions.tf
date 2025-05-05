terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.87.0"
    }
  }
  backend "s3" {
    endpoints         = {
    s3 = "https://storage.yandexcloud.net"
    }
    bucket     = "terraform-state-std-ext-013-12"
    region     = "ru-central1-a"
    key        = "terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_s3_checksum            = true
    skip_requesting_account_id  = true
    }
}