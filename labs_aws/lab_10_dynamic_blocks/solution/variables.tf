## AWS Specific parameters

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "profile" {
  type = string
}

## Environment and Project
variable "company" {
  type        = string
  description = "company name - will be used in tags"
}
variable "environment" {
  type        = string
  description = "e.g. test dev prod"
}

variable "project" {
  type = string
}

variable "lab_number" {
  type = string
}

## S3 Lifecycle Rules
variable "lifecycle_rules" {
  type = map(object({
    prefix          = string
    enabled         = bool
    transition_days = number
    transition_class = string
    expiration_days = number
  }))
  description = "Map of lifecycle rules for the S3 bucket"
}
