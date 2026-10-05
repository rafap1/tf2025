output "cidr_examples" {
  description = "CIDR function examples"
  value = {
    vpc_gateway   = local.vpc_gateway
    vpc_netmask   = local.vpc_netmask
    auto_subnets  = local.auto_subnets
    multi_subnets = local.multi_subnets
  }
}

output "zipmap_examples" {
  description = "Zipmap function examples"
  value = {
    server_ip_map  = local.server_ip_map
    server_configs = local.server_configs
  }
}

output "try_examples" {
  description = "Try function examples for error handling"
  value = {
    safe_cidr_valid   = local.safe_cidr_valid
    safe_cidr_invalid = local.safe_cidr_invalid
    safe_number       = local.safe_number
    safe_disk_sizes   = local.safe_disk_sizes
  }
}

output "can_examples" {
  description = "Can function examples for validation"
  value = {
    is_valid_cidr      = local.is_valid_cidr
    is_invalid_cidr    = local.is_invalid_cidr
    is_valid_ip_format = local.is_valid_ip_format
    validated_configs  = local.validated_configs
  }
}

output "coalesce_examples" {
  description = "Coalesce function examples"
  value = {
    default_machine_type = local.default_machine_type
    backup_settings      = local.backup_settings
  }
}

output "combined_examples" {
  description = "Combined function examples for robust code"
  value = {
    safe_subnets      = local.safe_subnets
    robust_env_config = local.robust_env_config
  }
}