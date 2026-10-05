locals {
  name_prefix = "${var.project}-${var.environment}-${var.lab_number}"
  name_prefix_with_region =  "${var.project}-${var.environment}-${var.lab_number}-${var.region}"
}
