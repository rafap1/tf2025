output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.this.bucket
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.this.arn
}

output "lifecycle_rules_summary" {
  description = "Summary of lifecycle rules applied"
  value = {
    for key, rule in var.lifecycle_rules : key => {
      prefix      = rule.prefix
      transition  = "${rule.transition_days}d -> ${rule.transition_class}"
      expiration  = "${rule.expiration_days}d"
    }
  }
}
