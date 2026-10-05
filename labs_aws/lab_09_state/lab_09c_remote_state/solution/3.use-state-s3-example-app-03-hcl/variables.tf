## Environment and Project
variable "environment" {
  type        = string
  description = "e.g. test dev prod"
  default     = "dev"
}

variable "project" {
  type    = string
  default = "proj99"
}

## AWS Specific parameters
variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "lab_number" {
  type = string
}
variable "profile" {
  type    = string
  default = "tfadmin1"
}

## EC2 Instance Parameters
variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type    = string
  default = "tf-course"
}


## Security Groups
variable "sec_allowed_external" {
  description = "CIDRs from which access is allowed"
  type        = list(string)
  default     = ["0.0.0.0/10", "0.0.0.0/10"]
}

