output "availability_zones_available" {
  value = data.aws_availability_zones.available.names
}
output "public_subnet_cidr" {
  value = [for i in range(var.az_count) : aws_subnet.public_subnet[i].cidr_block]
}

output "private_subnet_cidr" {
  value = [for i in range(var.az_count) : aws_subnet.private_subnet[i].cidr_block]
}

# Compare the two outputs below - one using 'for', the other using splat [*]
# You can see that with for we can "enrich the output"
output "db_subnet_cidr" {
  value = [for i in range(var.az_count) : "Subnet ${i + 1} with CIDR ${aws_subnet.db_subnet[i].cidr_block} in AZ: ${aws_subnet.db_subnet[i].availability_zone}"]
}

output "db_subnet_cidr_with_splat" {
  value = aws_subnet.db_subnet[*].cidr_block
}

## Use this to explore what are all the attributes of the aws_subnet we can use
# output "db_subnet" {
#     value = aws_subnet.db_subnet[*]
# }