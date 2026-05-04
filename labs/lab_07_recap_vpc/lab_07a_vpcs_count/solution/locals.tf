# locals {
#     az_public = zipmap(local.azs, var.public_subnets)
#     az_private = zipmap(local.azs, var.private_subnets)
#     az_database = zipmap(local.azs, var.database_subnets)
# }

locals {
  azs           = slice(data.aws_availability_zones.available.names, 0, 3)
  az_name       = data.aws_availability_zones.available.names
  az_id         = data.aws_availability_zones.available.zone_ids
  name_suffix   = "${var.project}-${var.environment}-${var.lab_number}"
  subnet_prefix = 8 # /24 subnets (16 + 8 = 24)
}
