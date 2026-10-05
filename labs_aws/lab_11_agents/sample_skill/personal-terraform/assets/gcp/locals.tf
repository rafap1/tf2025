locals {
  name_suffix = "${var.department}-${var.environment}"
  name_suffix_with_region = "${var.department}-${var.environment}-${var.region}"
}