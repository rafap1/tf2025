
locals {
  azs                = slice(data.aws_availability_zones.available.names, 0, 3)
  az_name            = data.aws_availability_zones.available.names
  az_id              = data.aws_availability_zones.available.zone_ids
  name_suffix        = "${var.project}-${var.environment}-${var.lab_number}"
  vpc_name_expresion = "${var.project}-${var.environment}"
  subnet_prefix      = 8 # /24 subnets (16 + 8 = 24)
}
