### ===================== GCP =================
variable "project_id" {
  type        = string
  description = "Project for tagging purposes"
}

variable "region" {
  type        = string
  description = "GCP region to deploy VM"
  default     = "europe-west1"

}

variable "zone" {
  type        = string
  description = "GCP zone to deploy VM"
  default     = "europe-west1-b"
}
### ===================== Course, Company and Environment =================

variable "lab_number" {
  type        = string
  description = "Lab number - sometimes help for resource uniqueness"
}

variable "student_number" {
  type        = string
  description = "Student number as in student-08"
}

variable "company" {
  type        = string
  description = "Company name for tagging purposes"
}

variable "department" {
  type        = string
  description = "Department name for tagging purposes"
  validation {
    condition     = var.department == "mdr" || var.department == "oad" || var.department == "sec"
    error_message = "The department must be one of 'mdr', 'oad', or 'sec'."
  }
}

variable "environment" {
  type        = string
  description = "Environment for tagging purposes"
  default     = "dev"
}

variable "app_name" {
  type        = string
  description = "Application name for tagging purposes"
  default     = "web"
}

variable "cost_center" {
  type        = string
  description = "Cost center for tagging purposes"
  default     = "12345"
}

