output "iam_principal_info" {
  description = "Info about IAM principal (user or role) used by Terraform to configure AWS"
  value       = data.aws_caller_identity.current
}

output "state_bucket_arn" {
  description = "State bucket ARN"
  value       = aws_s3_bucket.terraform_state.arn
}

output "state_bucket_name" {
  description = "State bucket ARN"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "state_bucket_versioning" {
  description = "Explicitly say versioning enabled or not"
  value       = aws_s3_bucket.terraform_state.versioning[0].enabled
  depends_on = [
    aws_s3_bucket_versioning.enabled
  ]
}

# output "state_full_bucket_info" {
#    description = "Full state bucket info for verification and troubleshooting"
#    value = aws_s3_bucket.terraform_state
#}

output "state_lock_dynamodb_name" {
  description = "database to use as lock for state files"
  value       = aws_dynamodb_table.terraform_state_locks.name
}