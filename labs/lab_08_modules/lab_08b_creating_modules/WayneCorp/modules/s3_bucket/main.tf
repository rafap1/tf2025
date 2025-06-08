
## Note we use the account ID to make sure the buckets are unique worldwide
resource "aws_s3_bucket" "my_bucket" {
  bucket = "${var.bucket_name}"

}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.my_bucket.id
  versioning_configuration {
    status = var.versioning ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.my_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}



resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket                  = aws_s3_bucket.my_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


