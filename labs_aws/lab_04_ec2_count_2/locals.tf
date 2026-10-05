locals {
  ninstances = length(var.instance_names)

  name_suffix = "${var.project}-${var.environment}-${var.lab_number}"
}
