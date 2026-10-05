output "public_ip" {
  description = "Public IP of instance"
  value       = aws_instance.server[*].public_ip
}

output "ami" {
  description = "AMI of instance"
  value       = aws_instance.server[*].ami
}

# output "instance_stuff" {
#   description = "all info about instance"
#   value       = aws_instance.server
# }

output "instance_id" {
  description = "Id of instance"
  value       = aws_instance.server[*].id
}


# output "ami_details" {
#   description = "Full details of selected AMI - e.g. for troubleshooting filter
#   value = data.aws_ami.amazon_linux2_kernel_5
# }



## To use for example in IAM policies or retrieving caller identity
data "aws_caller_identity" "current" {

}
output "user_identity" {
  description = "Info about IAM principal used by Terraform to configure AWS"
  value       = data.aws_caller_identity.current
}
