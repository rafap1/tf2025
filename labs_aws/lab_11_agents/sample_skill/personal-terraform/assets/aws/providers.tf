provider "aws" {
  region  = var.region
  profile = var.profile
  default_tags {
    tags = {
      "${var.company}:environment" = var.environment
      "${var.company}:project"     = var.project
      "${var.company}:cost-center" = var.cost_center   
      managed_by                   = "terraform"
    }
  }
}
