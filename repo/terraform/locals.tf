locals {
  env_suffix = var.git_branch == "main" ? "prod" : "dev"
  
  safe_vm_name = replace(lower("${var.vm_name}-${local.env_suffix}"), "/[^a-z0-9-]/", "-")
  
  vm_settings = {
    "main" = {
      vm_core = 4
      vm_ram  = 4
    }
    "develop" = {
      vm_core = 2
      vm_ram  = 2
    }
  }

  network_names = {
    net    = coalesce(var.vm_name_net, "net-${local.safe_vm_name}")
    innet  = coalesce(var.vm_name_innet, "innet-${local.safe_vm_name}")
    subnet = coalesce(var.vm_name_subnet, "subnet-${local.safe_vm_name}")
  }

  common_tags = {
    Environment = local.env_suffix
    Terraform   = "true"
    Project     = "pelmennaya"
  }
}