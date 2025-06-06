output "private_ips" {
  description = "Private IP addresses of all EC2 instances"
  value = {
    for name, instance in aws_instance.example :
    name => instance.private_ip
  }
}

output "instances_info" {
  description = "Map of instance info including public IP, private IP, instance type, and disk size"
  value = {
    for name, inst in aws_instance.example :
    name => {
      public_ip      = inst.public_ip
      private_ip     = inst.private_ip
      instance_type  = inst.instance_type
      disk_size_gb   = inst.root_block_device[0].volume_size
    }
  }
}