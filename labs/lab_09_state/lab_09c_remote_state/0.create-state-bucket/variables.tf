## Environment and Project
variable "environment" {
  type        = string
  description = "e.g. test dev prod"
  default     = "dev"
}

variable "company" {
  type        = string
  description = "company name - will be used in tags"
  default     = "acme"
}

variable "project" {
  description = "Project Name"
  type        = string
}

## AWS Specific parameters
variable "region" {
  description = "AWS Region"
  type        = string
}

variable "profile" {
  description = "AWS CLI profile to be used by Terraform when performing API calls"
  type        = string
}

variable "lab_number" {
  type = string
}