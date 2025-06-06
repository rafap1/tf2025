## AWS Specific parameters

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "profile" {
  type = string
}

## Lab specific variable
variable "ec2_instances" {
  description = "Map of instance name to instance properties"
  type = map(object({
    instance_type = string
    disk_size_gb  = number
  }))
  default = {
    "web-01" = {
      instance_type = "t3.nano"
      disk_size_gb  = 10
    }
    "web-02" = {
      instance_type = "t3.nano"
      disk_size_gb  = 12
    }
    "app-01" = {
      instance_type = "t3.micro"
      disk_size_gb  = 20
    }
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
  type = string
}

variable "lab_number" {
  type = string
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
  type        = string
  description = "TCP port where Foobar application listens"
}

