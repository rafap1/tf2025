module "my_bucket" {
  source      = "../../../s3_bucket"
  bucket_name = var.nombre_del_bucket
  versioning  = true
}