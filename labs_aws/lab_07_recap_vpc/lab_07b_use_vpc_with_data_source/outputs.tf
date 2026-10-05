output "private_subnet_ids" {
  value = data.aws_subnets.private_subnets.ids
}

output "vpc_id" {
  value = data.aws_vpc.my_vpc.id
}

output "data_private_subnets" {
  value = data.aws_subnets.private_subnets
}

output "vm_id_subnet_id" {
  value = [
    for i in range(var.num_vms) : "VM: ${aws_instance.private_vm[i].id} - ${aws_instance.private_vm[i].private_ip} -  ${aws_instance.private_vm[i].subnet_id}"
  ]
}

# # Uncomment to see detailed info of each subnet
# output "more_subnet_info" {
#   value = data.aws_subnet.private_subnet_info
# }

## This output enhances the "vm_id_subnet_id" above by adding the CIDR of each subnet
output "vm_id_subnet_id_cidr" {
  value = [
    for i in range(var.num_vms) :
    "VM: ${aws_instance.private_vm[i].id} - ${aws_instance.private_vm[i].private_ip} - Subnet ID: ${aws_instance.private_vm[i].subnet_id} - CIDR: ${data.aws_subnet.private_subnet_info[aws_instance.private_vm[i].subnet_id].cidr_block}"
  ]
}