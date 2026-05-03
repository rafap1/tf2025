locals {
  state_bucket_name   = "terraform-course-${data.aws_caller_identity.current.account_id}-state"
  dynamodb_table_name = "terraform-course-state-locks"
}