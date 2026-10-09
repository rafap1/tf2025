output "public_ip" {
  description = "Public IP of instance"
  value       = aws_instance.server1.public_ip
}

output "user_identity" {
  description = "Info about IAM principal used by Terraform to configure AWS"
  value       = data.aws_caller_identity.current
}

