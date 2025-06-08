locals {
  name_suffix           = "${var.project}-${var.environment}-${var.lab_number}"
  vpc_filter_expression = "${var.project}-${var.environment}"

  num_pub_subnets  = length(module.vpc_one.public_subnets)
  num_priv_subnets = length(module.vpc_one.private_subnets)

}


