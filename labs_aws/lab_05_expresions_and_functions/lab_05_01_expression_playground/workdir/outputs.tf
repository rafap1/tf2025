
# Outputs to test the expressions
output "practice_results" {
  value = {
    fruits_upper     = local.fruits_upper
    big_numbers      = local.big_numbers
    hex_colors       = local.hex_colors
    colors_info      = local.colors_info
    server_names     = local.server_names
    server_cpus      = local.server_cpus
    server_specs     = local.server_specs
    high_cpu_servers = local.high_cpu_servers
    employee_names   = local.employee_names
    engineers        = local.engineers
    salary_map       = local.salary_map
  }
}