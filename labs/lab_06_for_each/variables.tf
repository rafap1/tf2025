## AWS Specific parameters

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "profile" {
  type = string
}

## Lab specific variable
# variable "ec2_instances" {
#   description = "Map of instance name to instance properties"
#   type = map(object({
#     instance_type = string
#     disk_size_gb  = number
#     disk_type = string
#     cost_center = string
#   }))
# }

variable "ec2_instances" {
  description = "Map of instance name to instance properties"
  type = map(object({
    instance_type = string
    disk_size_gb  = number
    disk_type     = string
    cost_center   = string
  }))

  validation {
    condition = alltrue([
      for k, v in var.ec2_instances : contains(["gp2", "gp3"], v.disk_type)
    ])
    error_message = "The disk_type must be either 'gp2' or 'gp3'."
  }

  validation {
    condition = alltrue([
      for k, v in var.ec2_instances : contains(["t3.nano", "t3.micro"], v.instance_type)
    ])
    error_message = "The instance_type must be either 't3.nano' or 't3.micro'."
  }

  validation {
    condition = alltrue([
      for k, v in var.ec2_instances : v.disk_size_gb >= 8 && v.disk_size_gb <= 16
    ])
    error_message = "The disk_size_gb must be between 8 and 16 GB."
  }

  validation {
    condition = alltrue([
      for k, v in var.ec2_instances : contains(["11111", "22222", "33333"], v.cost_center)
    ])
    error_message = "The cost_center must be one of '11111', '22222', or '33333'."
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

