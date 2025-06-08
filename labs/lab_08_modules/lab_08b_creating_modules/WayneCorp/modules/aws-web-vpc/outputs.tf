output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.web_server_vpc.id
}

output "subnet_id" {
  description = "ID of the created subnet"
  value       = aws_subnet.web_server_subnet.id
}

output "subnet_cidr" {
  description = "CIDR of the created subnet"
  value       = aws_subnet.web_server_subnet.cidr_block
}

output "subnet_az" {
  description = "Availability Zone of created subnet"
  value = aws_subnet.web_server_subnet.availability_zone
}

output "web_sec_group_id" {
  description = "Id of security group created in VPC"
  value = aws_security_group.web_server_sg_name.id
}