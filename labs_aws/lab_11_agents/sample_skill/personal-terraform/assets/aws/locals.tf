locals {
  name_suffix = "${var.project}-${var.environment}"
  name_suffix_with_region = "${var.project}-${var.environment}-${var.region}"
}
