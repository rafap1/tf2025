output "vpc_id" {
  description = "ID of the vpc"
  value       = module.vpc_proj2.vpc_id
}

output "subnet_id" {
  description = "ID of the vpc"
  value       = module.vpc_proj2.subnet_id
}

output "subnet_cidr" {
  description = "CIDR of subnet"
  value       = module.vpc_proj2.subnet_cidr
}

output "subnet_availability_zone" {
  description = "AZ of subnet"
  value       = module.vpc_proj2.subnet_az
}

output "web2_instance_id" {
  description = "ID of EC2 instance"
  value       = module.web_proj2.instance_id
}

output "web2_public_ip" {
  description = "Public IP of server 2"
  value       = module.web_proj2.instance_public_ip
}