provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
  default_labels = {
    "${var.company}:department"  = var.department
    "${var.company}:environment" = var.environment
    "${var.company}:cost-center" = var.cost_center
    managed_by                   = "terraform"
  }
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
  default_labels = {
    "${var.company}:department"  = var.department
    "${var.company}:environment" = var.environment
    "${var.company}:cost-center" = var.cost_center
    managed_by                   = "terraform"
  }
}
