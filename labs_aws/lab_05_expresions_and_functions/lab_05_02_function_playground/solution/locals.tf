# Function Playground - Practice Terraform Built-in Functions
# No provider needed - use `terraform console` to test these functions

locals {
  # ===== CIDR FUNCTIONS =====

  # 1. cidrhost - Get specific IP from CIDR
  vpc_gateway = cidrhost("10.0.0.0/16", 1) # 10.0.0.1
  vpc_dns     = cidrhost("10.0.0.0/16", 2) # 10.0.0.2

  # 2. cidrnetmask - Get netmask from CIDR
  vpc_netmask = cidrnetmask("10.0.0.0/16") # 255.255.0.0

  # 3. cidrsubnet - Create subnets from larger CIDR
  auto_subnets = [
    cidrsubnet("10.0.0.0/16", 8, 1), # 10.0.1.0/24
    cidrsubnet("10.0.0.0/16", 8, 2), # 10.0.2.0/24
    cidrsubnet("10.0.0.0/16", 8, 3), # 10.0.3.0/24
  ]

  # 4. cidrsubnets - Create multiple subnets at once
  multi_subnets = cidrsubnets("10.0.0.0/16", 8, 8, 8, 4) # Different sizes

  # ===== ZIPMAP FUNCTION =====

  # 5. zipmap - Combine two lists into a map
  server_ip_map = zipmap(["web", "api", "db"], ["10.0.1.10", "10.0.1.20", "10.0.1.30"])

  # 6. zipmap with for expression
  server_configs = zipmap(
    ["web", "api", "db"],
    [for ip in ["10.0.1.10", "10.0.1.20", "10.0.1.30"] : "http://${ip}:80"]
  )

  # ===== TRY FUNCTION (Error Handling) =====

  # 7. try - Handle potential errors gracefully
  safe_cidr_valid   = try(cidrnetmask("192.168.1.0/24"), "invalid")  # "255.255.255.0"
  safe_cidr_invalid = try(cidrnetmask("10.0.0.0"), "bad CIDR amigo") # "bad CIDR amigo"

  # 8. try with multiple fallbacks
  safe_number = try(
    tonumber("42"),
    tonumber("not-a-number"),
    0 # final fallback
  )

  # 9. try with nested object access
  safe_disk_sizes = {
    for env, config in {
      dev     = { machine_type = "e2-micro" }
      staging = { machine_type = "e2-small", disk_size = 20 }
      prod    = { machine_type = "e2-medium", disk_size = 50 }
    } : env => try(config.disk_size, 10)
  }

  # ===== CAN FUNCTION (Validation) =====

  # 10. can - Test if expression is valid
  is_valid_cidr   = can(cidrnetmask("192.168.1.0/24")) # true
  is_invalid_cidr = can(cidrnetmask("10.0.0.0"))       # false

  # 11. can with regex
  is_valid_ip_format = can(regex("^[0-9.]+$", "192.168.1.1")) # true

  # 12. can for conditional logic
  validated_configs = {
    for env, config in {
      dev     = { machine_type = "e2-micro" }
      staging = { machine_type = "e2-small", disk_size = 20 }
      prod    = { machine_type = "e2-medium", disk_size = 50, backup_enabled = true }
      } : env => {
      machine_type = config.machine_type
      disk_size    = can(config.disk_size) ? config.disk_size : 10
      has_backup   = can(config.backup_enabled) ? config.backup_enabled : false
    }
  }

  # ===== COALESCE FUNCTION (First Non-null) =====

  # 13. coalesce - Return first non-null value
  default_machine_type = coalesce(
    try({ machine_type = "e2-micro" }.missing_field, null),
    "e2-micro"
  )

  # 14. coalesce with multiple fallbacks
  backup_settings = {
    for env in ["dev", "staging", "prod"] : env => {
      backup_enabled = coalesce(
        try({ prod = true }[env], null),
        env == "prod" ? true : false,
        false
      )
    }
  }

  # ===== COMBINED EXAMPLES =====

  # 15. Robust subnet creation with validation
  safe_subnets = [
    for i, cidr in ["10.0.1.0/24", "10.0.2.0/24", "invalid-cidr"] : {
      name    = "subnet-${i + 1}"
      cidr    = cidr
      gateway = try(cidrhost(cidr, 1), "invalid")
      valid   = can(cidrnetmask(cidr))
    }
  ]

  # 16. Environment configuration with all safety functions
  robust_env_config = {
    for env, config in {
      dev     = { machine_type = "e2-micro" }
      staging = { machine_type = "e2-small", disk_size = 20 }
      prod    = { machine_type = "e2-medium", disk_size = 50, backup_enabled = true }
      } : env => {
      machine_type   = coalesce(try(config.machine_type, null), "e2-micro")
      disk_size      = try(config.disk_size, 10)
      backup_enabled = coalesce(try(config.backup_enabled, null), env == "prod")
      valid_config   = can(config.machine_type) && can(tonumber(try(config.disk_size, 10)))
    }
  }
}