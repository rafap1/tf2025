resource "aws_s3_bucket" "bucket" {
  bucket = "bucket-${local.name_suffix}"
}
