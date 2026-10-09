locals {
  name_suffix             = "${var.project}-${var.environment}"
  name_suffix_with_region = "${var.project}-${var.environment}-${var.location}"

  ## azurerm has no default tags: use as  tags = local.common_tags
  ## or, to add resource specific tags:   tags = merge(local.common_tags, { role = "web" })
  common_tags = {
    "${var.company}:environment" = var.environment
    "${var.company}:project"     = var.project
    "${var.company}:cost-center" = var.cost_center
    managed_by                   = "terraform"
  }
}
