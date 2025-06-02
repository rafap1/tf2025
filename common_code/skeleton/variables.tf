## AWS Specific parameters

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "profile" {
  type    = string
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
}

variable "lab_number"{
  type = string 
  default = "lab02"
}

## VPC parameters
variable "vpc_cidr" {
  type    = string
  default = "10.99.0.0/16"
  validation {
    condition     = can(cidrnetmask(var.vpc_cidr)) 
    error_message = "Invalid CIDR for VPC."
  }
}

## EC2 Instance Parameters

variable "instance_type" {
  type    = string
  default = "t3.micro"
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
}

## ECS Parameters
variable "special_port" {
  type = string
  description = "TCP port where Foobar application listens"
}

