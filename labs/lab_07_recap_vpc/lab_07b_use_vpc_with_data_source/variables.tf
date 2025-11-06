## AWS Specific parameters

variable "region" {
  type    = string
  default = "eu-south-2"
}

variable "profile" {
  type    = string
  default = "sso-student"
}

## Environment and Project
## Important - used to match vpc and subnets in data source filters
variable "company" {
  type        = string
  description = "company name - will be used in tags"
}
variable "environment" {
  type        = string
  description = "e.g. test dev prod"
}

variable "project" {
  type        = string
  description = "Project name - used in tags and resource naming"
}

variable "lab_number" {
  type        = string
  description = "Lab number - used in tags and resource naming"
}

## VPC and subnet parameters

## WE do not really need the az_count explicitly in lab 07b
## We get the value implicitly from the number of private subnets (size of the data source)
# variable "az_count" {
#   type    = number
#   default = 2
#   validation {
#     condition     = var.az_count >= 1 && var.az_count <= 3
#     error_message = "AZ count must be between 1 and 3."
#   }
# }

variable "num_vms" {
  type = number
  validation {
    condition     = var.num_vms >= 0 && var.num_vms <= 5
    error_message = "Number of VMs must be between 0 and 5."
  }
}

variable "instance_type" {
  type    = string
  default = "t3.nano"
}

