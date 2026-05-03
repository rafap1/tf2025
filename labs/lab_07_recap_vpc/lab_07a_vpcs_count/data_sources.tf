
data "aws_availability_zones" "available" {
  state = "available"
}



## Data Source - this is used to get the latest Ubuntu AMI
## It is equivalent to a query to aws with a filter:
## "Give me the ami-id of the latest ubuntu 24.04 image for X86 architecture"
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
