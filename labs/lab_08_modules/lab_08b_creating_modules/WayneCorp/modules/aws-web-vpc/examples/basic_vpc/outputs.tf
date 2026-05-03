output "vpc_id" {
  description = "ID of the vpc"
  value       = module.basic_vpc.vpc_id
}

output "subnet_id" {
  description = "ID of the vpc"
  value       = module.basic_vpc.subnet_id
}

output "subnet_cidr" {
  description = "CIDR of subnet"
  value       = module.basic_vpc.subnet_cidr
}

output "subnet_az" {
  description = "AZ of the subnet"
  value       = module.basic_vpc.subnet_az
}
