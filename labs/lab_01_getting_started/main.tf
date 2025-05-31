terraform {
  required_version = "~> 1.11.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
}

provider "aws" {
  profile = "sso-student"
  region  = "eu-south-2"
}

## Data Source - this is used to get the latest Ubuntu AMI
## It is equivalent to a query to aws with a filter:
## "Give me the ami-id of the latest ubuntu 24.04 image for X86 architecture"
## Data sources are very useful!  More later in the course
data "aws_ami" "ubuntu_24_04_x86" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/*24.04-amd64-server*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}
## Here we declare some variables that are used later when creating resources
## We give the variable a default value - later in the course we see other ways to populate variables.

variable "instance_type" {
  description = "instance type"
  type        = string
  default     = "t3.micro"
  # Validation of the instance type - must be t3.micro or t2.micro
  validation {
    condition     = var.instance_type == "t3.micro" || var.instance_type == "t3.nano"
    error_message = "The instance type must be t3.micro or t3.nano"
  }
}


## Since we do not specify subnet AWS 
## will select a public subnet in the default VPC
resource "aws_instance" "server" {
  ami                         = var.my_ubuntu_ami
  instance_type               = var.instance_type
  tags = {
    Name = "web-server"
  }
}
