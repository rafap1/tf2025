locals {
  name_suffix     = "${var.project}-${var.environment}-lab${var.lab_number}"
  create_instance = true
  num_instances   = 3

}

