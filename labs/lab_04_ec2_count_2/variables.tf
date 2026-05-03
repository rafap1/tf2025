## AWS Specific parameters

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "profile" {
  type    = string
  default = "sso-student"
}


variable "lab_number" {
  type    = string
  default = "lab04"
}

## Names of instances
variable "instance_names" {
  type    = list(string)
  default = ["dep1", "dep2", "dep3", "dep4"]
  validation {
    condition     = length(var.instance_names) > 0 && length(var.instance_names) <= 4
    error_message = "Wrong number of instance names"
  }
}


## Environment and Project
variable "company" {
  type        = string
  description = "company name - will be used in tags"
  default     = "lumon"
}
variable "environment" {
  type        = string
  description = "e.g. test dev prod"
  default     = "dev"
}

variable "project" {
  type    = string
  default = "proj99"
}

## VPC parameters
variable "vpc_cidr" {
  type    = string
  default = "10.99.0.0/16"
  validation {
    condition     = can(cidrnetmask(var.vpc_cidr)) ## Needs work
    error_message = "Invalid CIDR for VPC."
  }
}

## EC2 Instance Parameters

variable "instance_type" {
  type    = string
  default = "t3.nano"
}

variable "my_ami" {
  description = "ami for EC2 instance"
  type        = string
  default     = "ami-0b752bf1df193a6c4"
}

# variable "key_name" {
#   type = string
#   default = "tf-course"
# }


## Security Groups
variable "sec_allowed_external" {
  description = "CIDRs from which access is allowed"
  type        = list(string)
  default     = ["0.0.0.0/0"]
  # default = ["2.37.1.5/32"]
}

## ECS Parameters
variable "special_port" {
  type        = string
  description = "TCP port where Foobar application listens"

}

